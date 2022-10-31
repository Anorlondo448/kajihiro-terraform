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

data "terraform_remote_state" "ecs" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "kajihiro-terraform"
    key    = "dev/ecs/terraform.tfstate"
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

  # ECS
  ecs_cluster_name = data.terraform_remote_state.ecs.outputs.ecs_cluster_name
  ecs_service_ec2_name = data.terraform_remote_state.ecs.outputs.ecs_service_ec2_name
  ecs_service_fargate_name = data.terraform_remote_state.ecs.outputs.ecs_service_fargate_name
  alb_listner_arn = data.terraform_remote_state.ecs.outputs.alb_listner_arn
  alb_target_group_blue_name = data.terraform_remote_state.ecs.outputs.alb_target_group_blue_name
  alb_target_group_green_name = data.terraform_remote_state.ecs.outputs.alb_target_group_green_name
}
