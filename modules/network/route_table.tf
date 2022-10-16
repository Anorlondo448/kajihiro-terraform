###
#
# Route Table
#
# main
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.system}-${var.env}"
  }
}

# association main
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.main.id
}

# association public subnet
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.main.id
}


resource "aws_route_table" "private" {
  count  = length(var.subnet_private_cidr)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "${var.system}-${var.env}"
  }
}

# association private subnet
resource "aws_route_table_association" "private" {
  count          = length(var.subnet_private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
