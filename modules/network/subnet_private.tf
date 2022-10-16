#----------
# Private Subnet 
#----------
resource "aws_subnet" "private" {
  count             = length(var.subnet_private_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.subnet_private_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.system}-${var.env}"
  }
}