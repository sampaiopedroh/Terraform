module "aws-prod" {
  source = "../../infra"

  nomeECR            = "ecr-producao"
  nomeBucket         = "prince-prod"
  nomeBeanstalk      = "producao"
  descricaoBeanstalk = "aplicacao-de-producao"
  tipoInstancia      = "t2.micro"
  qtdMaxInstancias   = 5
  ambienteBeanstalk  = "ambiente-de-producao" 
}