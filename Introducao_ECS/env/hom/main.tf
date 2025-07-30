module "aws-hom" {
    source = "../../infra"

    nome_repositorio = "ecr-homol"
    nome_vpc         = "vpc-ecs-homol"
    cargo_iam        = "homol" 
    ambiente         = "homol"
    cpu              = 256
    memory           = 512
}

output "IP_lb" {
    value = module.aws-prod.IP
}