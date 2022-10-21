###
#
# Elastic Container Service
#
resource "aws_ecs_cluster" "main" {
  name = "${var.system}-${var.env}-cluster"
}
