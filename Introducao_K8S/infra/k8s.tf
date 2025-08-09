resource "kubernetes_service_account_v1" "aws_lb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_lb_controller.arn
    }
  }
}

resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.9.4"

  set {
    name  = "clusterName"
    value = var.nome_cluster
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account_v1.aws_lb_controller.metadata[0].name
  }

  depends_on = [
    kubernetes_service_account_v1.aws_lb_controller
  ]
}

# --- DEPLOYMENT DA SUA APLICAÇÃO DJANGO ---

resource "kubernetes_deployment" "Django-API" {
  depends_on = [helm_release.aws_lb_controller] # Depende do LBC estar pronto

  metadata {
    name = "django-api"
    labels = {
      nome = "django"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        nome = "django"
      }
    }
    template {
      metadata {
        labels = {
          nome = "django"
        }
      }
      spec {
        container {
          image = "327990815065.dkr.ecr.us-east-2.amazonaws.com/ecr-producao:v1"
          name  = "django"
          port {
            container_port = 8000
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "lb" {
  depends_on = [kubernetes_deployment.Django-API]

  metadata {
    name = "lb-django-api"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    selector = {
      nome = "django"
    }
    port {
      port        = 80
      target_port = 8000
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service" "nomeDNS" {
  metadata {
    name = kubernetes_service.lb.metadata[0].name
  }
  depends_on = [kubernetes_service.lb]
}

output "URL" {
  description = "URL do Load Balancer da API Django"
  value       = data.kubernetes_service.nomeDNS.status[0].load_balancer[0].ingress[0].hostname
}