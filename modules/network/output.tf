output "vpc_id" {
  value = aws_vpc.vpc.*.id[0]
}

output "subnet_public_id" {
  value = aws_subnet.public.*.id[0]
}
