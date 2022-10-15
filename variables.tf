###
#
# Common
#

## 識別子としてアプリ名を指定します
variable "app-name" {
  type    = string
  default = "kajihiro-terraform"
}

## AWS上で使用するリージョンを指定します
variable "region" {
  type    = string
  default = "us-east-1"
}

data "aws_caller_identity" "current" {}