#----------
# Terraform
#----------
terraform {
  backend "s3" {
    bucket = "kajihiro-terraform"
    key    = "dev/deploy/terraform.tfstate"
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
# Remote State
#----------
data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "kajihiro-terraform"
    key    = "dev/ecr/terraform.tfstate"
  }
}



#----------
# Resource - Deploy
#----------
module "deploy" {
  source = "../../../modules/deploy"

  # common
  system = "kajihiro-terraform"
  env    = "dev"

  # Repository
  repository_frontend = data.terraform_remote_state.ecr.outputs.repository_frontend_name
}
