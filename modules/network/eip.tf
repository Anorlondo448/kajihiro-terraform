###
#
# Elastic IP
#
resource "aws_eip" "ngw" {
  count             = length(var.subnet_private_cidr)
  vpc = true

  tags = {
    Name = "${var.system}-${var.env}-eip"
  }
}