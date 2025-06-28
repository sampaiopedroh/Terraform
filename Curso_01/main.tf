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
	region = "us-east-2"
}

resource "aws_instance" "app_serve" {
	ami = "ami-0d1b5a8c13042c939"
	instance_type = "t2.micro"
	key_name = "iac-alura"
	tags = {
		Name = "HelloWorld - Terraform"
	}
}