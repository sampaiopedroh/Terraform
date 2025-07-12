module "aws-dev" {
    source = "../../infra"
    instancia = "t2.micro"
    regiao_aws = "us-east-2"
    chave_ssh = "IaC-DEV"
    nome_sg = "acesso_geral_dev"
    descricao_sg = "grupo de Dev"
    nomeGrupo = "DEV"
    maximoGrupo = 5
    minimoGrupo = 0
    producao = false
}