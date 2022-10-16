#----------
# Resource - Network
#----------
output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_public_id" {
  value = module.network.subnet_public_id
}

output "subnet_private_id" {
  value = module.network.subnet_private_id
}

output "security_group_id_allow_http_from_any" {
  value = module.network.security_group_id_allow_http_from_any
}