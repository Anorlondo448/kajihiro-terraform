#----------
# Terraform
#----------
terraform {
  backend "s3" {
    bucket = "kajihiro-terraform"
    key    = "dev/ecr/terraform.tfstate"
    region = "us-east-1"
    profile = "default"
  }
}

#----------
# Provider
#----------
provider "aws" {
  region = "us-east-1"
}

#----------
# Resource - ECR
#----------
module "ecr" {
  source = "../../../modules/ecr"

  # common
  system = "kajihiro-terraform"
  env    = "dev"
}
