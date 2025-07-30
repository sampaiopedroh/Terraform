# Cria o cluster ECS
resource "aws_ecs_cluster" "main" {
  name = var.ambiente

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Define a capacidade do provedor (Fargate)
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }
}

resource "aws_ecs_task_definition" "django-api" {
    family                   = "Django-API"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = var.cpu
    memory                   = var.memory
    execution_role_arn       = aws_iam_role.cargo.arn

    #Config containers
    container_definitions = jsonencode([
      {
        "name" : var.ambiente,
        "image": "327990815065.dkr.ecr.us-east-2.amazonaws.com/ecr-producao:v1",
        "cpu": var.cpu,
        "memory": var.memory,
        "essential": true,
        "portMappings": [
          {
            "containerPort": 8000,
            "hostPort": 8000
          }
        ]
      }
    ])
}

resource "aws_ecs_service" "django-api" {
    name            = "Django-API"
    cluster         = aws_ecs_cluster.main.id # Usa o ID do cluster ECS criado
    task_definition = aws_ecs_task_definition.django-api.arn
    desired_count   = 3

    load_balancer {
        target_group_arn = aws_lb_target_group.alvo.arn
        container_name   = var.ambiente
        container_port   = 8000
    }

    network_configuration {
        subnets         = module.vpc.private_subnets
        security_groups = [aws_security_group.privado.id]
    }

    capacity_provider_strategy {
        capacity_provider = "FARGATE"
        weight            = 1 #100%
    }
}