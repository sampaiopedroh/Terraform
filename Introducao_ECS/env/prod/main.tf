module "aws-prod" {
    source = "../../infra"

    nome_repositorio = "ecr-producao"
    nome_vpc         = "vpc-ecs-producao"
    cargo_iam        = "producao" 
    ambiente         = "producao"
    cpu              = 256
    memory           = 512
}

output "IP_lb" {
    value = module.aws-prod.IP
}