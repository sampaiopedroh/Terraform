terraform {
  backend "s3" {
    bucket = "terraform-state-prince"
    key    = "prod/terraform.tfstate"
    region = "us-east-2"
  }
}