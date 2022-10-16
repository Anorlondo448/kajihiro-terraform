#----------
# Resource - S3
#----------
output "s3_arn" {
  value = module.s3.s3_arn
}


#----------
# Resource - Network
#----------
output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_public_id" {
  value = module.network.subnet_public_id
}