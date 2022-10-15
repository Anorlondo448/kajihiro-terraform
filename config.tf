###
#
# Remote State
#
terraform {
  backend "s3" {
    bucket = "kajihiro-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
    profile = "default"
  }
}