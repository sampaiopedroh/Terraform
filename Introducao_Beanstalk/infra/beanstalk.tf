resource "aws_elastic_beanstalk_application" "aplicacao_beanstalk" {
  name        = var.nomeBeanstalk
  description = var.descricaoBeanstalk
}

resource "aws_key_pair" "chaveSSH" {
	key_name = "IaC-PROD"
	public_key = file("IaC-PROD.pub")
	
}

resource "aws_elastic_beanstalk_environment" "ambiente_beanstalk" {
  name                = var.ambienteBeanstalk
  application         = aws_elastic_beanstalk_application.aplicacao_beanstalk.name
  solution_stack_name = "64bit Amazon Linux 2 v4.2.1 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.tipoInstancia
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.qtdMaxInstancias
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.chaveSSH.key_name
  }
}

resource "aws_elastic_beanstalk_application_version" "default" {
  depends_on = [
    aws_elastic_beanstalk_environment.ambiente_beanstalk,
    aws_elastic_beanstalk_application.aplicacao_beanstalk,
    aws_s3_bucket_object.docker
  ]
  name        = var.ambienteBeanstalk
  application = var.nomeBeanstalk
  description = var.descricaoBeanstalk
  bucket      = aws_s3_bucket.beanstalk_deploys.id
  key         = aws_s3_bucket_object.docker.id
}