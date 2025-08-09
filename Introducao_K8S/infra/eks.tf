module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.nome_cluster
  kubernetes_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_private_access = true
  endpoint_public_access  = true

  eks_managed_node_groups = {
    prince = {
      name         = "prince"
      min_size     = var.tamanho_min_node
      max_size     = var.tamanho_max_node
      desired_size = var.qtd_desejada_node

      instance_types = ["t3.small"]
      iam_role_arn   = aws_iam_role.eks_nodes.arn
    }
  }
}