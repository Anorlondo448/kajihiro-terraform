###
#
# Nat Gateway
#
resource "aws_nat_gateway" "ngw" {
  count = length(var.subnet_private_cidr)

  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.system}-${var.env}"
  }
}