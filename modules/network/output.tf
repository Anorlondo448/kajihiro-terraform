output "vpc_id" {
  value = aws_vpc.vpc.*.id
}

output "subnet_public_id" {
  value = aws_subnet.public.*.id
}

output "subnet_private_id" {
  value = aws_subnet.private.*.id
}

output "security_group_id_allow_http_from_any" {
  value = aws_security_group.allow_http_from_any.id
}
