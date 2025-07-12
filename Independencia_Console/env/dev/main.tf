module "aws-dev" {
    source = "../../infra"
    instancia = "t2.micro"
    regiao_aws = "us-east-2"
    chave_ssh = "IaC-DEV"
    nome_sg = "acesso_geral_dev"
    descricao_sg = "grupo de Dev"
}

output "IP" {
    value = module.aws-dev.IP_publico
}