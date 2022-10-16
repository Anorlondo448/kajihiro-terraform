#----------
# Terraform
#----------
terraform {
  required_version = "4.34.0"
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
# Remote State
#----------
data "terraform_remote_state" "remote_state" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "kajihiro-terraform"
    key    = "dev/terraform.tfstate"
  }
}

#----------
# Resource - Network
#----------
module "network" {
  source = "../../modules/network"

  # common
  system = "kajihiro-terraform"
  env    = "dev"
  
  # vpc
  vpc_cidr = "10.100.0.0/16"
  
  # flow_log
  flow_log_destination = data.terraform_remote_state.storage.outputs.s3_log_arn
  
  # subnet_public
  subnet_public_cidr = ["10.100.1.0/24", 
                        "10.100.2.0/24",
                        "10.100.3.0/24",
                        "10.100.4.0/24",
                        "10.100.5.0/24",
                        "10.100.6.0/24"
                        ]

