###
#
# Security Group
#
resource "aws_security_group" "allow_http_from_any" {
  name        = "${var.system}-${var.env}-allow-http-from-any"
  description = "Allow HTTP from Any"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.system}-${var.env}"
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}