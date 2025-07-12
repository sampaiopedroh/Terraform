module "aws-prod" {
    source = "../../infra"
    instancia = "t2.micro"
    regiao_aws = "us-east-2"
    chave_ssh = "IaC-PROD"
    nome_sg = "acesso_geral_prod"
    descricao_sg = "grupo de Prod"
}

output "IP" {
    value = module.aws-prod.IP_publico
}