module "aws-dev" {
    source                   = "../../infra"
    instancia                = "t2.micro"
    regiao_aws               = "us-east-2"
    chave_ssh                = "IaC-DEV"
    nome_sg                  = "acesso_geral_dev"
    descricao_sg             = "grupo de Dev"
    nomeGrupo                = "DEV"
    maximoGrupo              = 5
    minimoGrupo              = 0
    producao                 = false
    maximoLigado             = 5
    minimoLigado             = 0
    quandidadeLigadoDesejada = 1
    recurrenceLigado         = "0 10 * * MON-FRI"
    recurrenceDesligado      = "0 21 * * MON-FRI"
}