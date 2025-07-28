module "aws-hom" {
  source = "../../infra"

  nomeECR            = "ecr-homol"
  nomeBucket         = "prince-hom"
  nomeBeanstalk      = "homol"
  descricaoBeanstalk = "aplicacao-de-homol"
  tipoInstancia      = "t2.micro"
  qtdMaxInstancias   = 3
  ambienteBeanstalk  = "ambiente-de-homol" 
}