#----------
# Public Subnet 
#----------
resource "aws_subnet" "public" {
  count             = length(var.subnet_public_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.subnet_public_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.system}-${var.env}"
  }
}