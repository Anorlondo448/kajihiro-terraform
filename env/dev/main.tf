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
# Remote State
#----------
data "terraform_remote_state" "dev" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "kajihiro-terraform"
    key    = "dev/terraform.tfstate"
  }
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

#----------
# Resource - Network
#----------
module "network" {
  source = "../../modules/network"

  # common
  system = "kajihiro-terraform"
  env    = "dev"
  
  # vpc
  vpc_cidr = "10.50.0.0/16"
  
  # flow_log
  flow_log_destination = data.terraform_remote_state.dev.outputs.s3_arn
  
  # subnet_public
  subnet_public_cidr = ["10.50.1.0/24", 
                        "10.50.2.0/24",
                        "10.50.3.0/24"
                        ]

  # subnet_private
  subnet_private_cidr = ["10.50.101.0/24", 
                         "10.50.102.0/24",
                         "10.50.103.0/24"
                        ]

}
