module "aws-prod" {
  source = "../../infra"

  nome_repositorio  = "ecr-producao"
  nome_vpc          = "vpc-eks-producao"
  nome_cluster      = "prod-prince"
  tamanho_min_node  = 1
  tamanho_max_node  = 3
  qtd_desejada_node = 2
}

output "URL_do_Load_Balancer" {
  description = "URL do Load Balancer da API Django"
  value       = module.aws-prod.URL
}