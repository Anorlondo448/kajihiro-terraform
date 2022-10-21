#----------
# Terraform
#----------
terraform {
  backend "s3" {
    bucket = "kajihiro-terraform"
    key    = "dev/ecs/terraform.tfstate"
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
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "kajihiro-terraform"
    key    = "dev/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "kajihiro-terraform"
    key    = "dev/ecr/terraform.tfstate"
  }
}

#----------
# Resource - ECS
#----------
module "ecs" {
  source = "../../../modules/ecs"

  # common
  system = "kajihiro-terraform"
  env    = "dev"

  # VPC
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  # Public Subnet
  subnet_public_id = data.terraform_remote_state.network.outputs.subnet_public_id
  
  # Private Subnet
  subnet_private_id = data.terraform_remote_state.network.outputs.subnet_private_id

  # Security Group
  security_group_id_allow_http_from_any = data.terraform_remote_state.network.outputs.security_group_id_allow_http_from_any

  # Repository
  repository_frontend = data.terraform_remote_state.ecr.outputs.repository_frontend_name

}
