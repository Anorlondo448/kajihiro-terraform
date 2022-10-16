###
#
# VPC
#
# VPC
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.system}-${var.env}"
  }
}

# VPC Flow Logs
resource "aws_flow_log" "flow_log" {
  log_destination      = var.flow_log_destination
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}
