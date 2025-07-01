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

resource "aws_instance" "app_serve" {
	ami = "ami-0d1b5a8c13042c939"
	instance_type = var.instancia
	key_name = var.chave_ssh
	tags = {
		Name = "Terraform e Ansible para python"
	}
}

resource "aws_key_pair" "chaveSSH" {
	key_name = var.chave_ssh
	public_key = file("${var.chave_ssh}.pub")
	
}