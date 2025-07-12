terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 3.17"
		}
	}

	required_version = ">= 0.14.9"
}

provider "aws" {
	profile = "default"
	region = var.regiao_aws
}

resource "aws_launch_template" "maquina" {
	image_id = "ami-0d1b5a8c13042c939"
	instance_type = var.instancia
	key_name = var.chave_ssh
	tags = {
		Name = "Terraform e Ansible para python"
	}
	security_group_names = [ var.nome_sg ]
	user_data = var.producao ? filebase64("ansible.sh") : ""
}

resource "aws_key_pair" "chaveSSH" {
	key_name = var.chave_ssh
	public_key = file("${var.chave_ssh}.pub")
	
}

resource "aws_autoscaling_group" "grupo" {
	availability_zones = [ "${var.regiao_aws}a", "${var.regiao_aws}b" ]
	name = var.nomeGrupo
	max_size = var.maximoGrupo
	min_size = var.minimoGrupo
	launch_template {
		id = aws_launch_template.maquina.id
		version = "$Latest"
	}
	target_group_arns = var.producao ? [ aws_lb_target_group.alvo_lb[0].arn ] : []
}

resource "aws_default_subnet" "subnet_1" {
	availability_zone = "${var.regiao_aws}a"
}

resource "aws_default_subnet" "subnet_2" {
	availability_zone = "${var.regiao_aws}b"
}

resource "aws_lb" "load_balancer" {
	internal = false
	subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ]
	security_groups = [ aws_security_group.acesso_geral.id ]
	count = var.producao ? 1 : 0
}

resource "aws_default_vpc" "default" {}

resource "aws_lb_target_group" "alvo_lb" {
	name = "maquinasAlvo"
	port = "8000"
	protocol = "HTTP"
	vpc_id = aws_default_vpc.default.id
	count = var.producao ? 1 : 0

}

resource "aws_lb_listener" "entrada_lb" {
	load_balancer_arn = aws_lb.load_balancer[0].arn
	port = "8000"
	protocol = "HTTP"
	default_action {
		type = "forward"
		target_group_arn = aws_lb_target_group.alvo_lb[0].arn
	}
	count = var.producao ? 1 : 0
}

resource "aws_autoscaling_policy" "escala_producao" {
	name = "terraform-escala"
	autoscaling_group_name = var.nomeGrupo
	policy_type = "TargetTrackingScaling"
	target_tracking_configuration {
		predefined_metric_specification {
			predefined_metric_type = "ASGAverageCPUUtilization"
		}
		target_value = 50.0
	}
	count = var.producao ? 1 : 0
}