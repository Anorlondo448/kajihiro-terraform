#----------
# Terraform
#----------
terraform {
  backend "s3" {
    bucket = "kajihiro-terraform"
    key    = "dev/terraform.tfstate"
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
# Resource - S3
#----------
module "s3" {
  source = "../../modules/s3"

  # common
  system = "kajihiro-terraform"
  env    = "dev"
}
