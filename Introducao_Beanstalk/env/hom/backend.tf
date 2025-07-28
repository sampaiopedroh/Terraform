terraform {
  backend "s3" {
    bucket = "terraform-state-prince"
    key    = "hom/terraform.tfstate"
    region = "us-east-2"
  }
}