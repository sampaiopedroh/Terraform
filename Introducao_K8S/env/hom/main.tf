module "aws-hom" {
    source = "../../infra"

    nome_repositorio  = "ecr-homol"
    nome_vpc          = "vpc-ecs-homol"
    nome_cluster      = "homol"
    tamanho_min_node  = 1
    tamanho_max_node  = 2
    qtd_desejada_node = 1
}