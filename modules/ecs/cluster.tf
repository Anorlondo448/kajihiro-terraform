###
#
# Elastic Container Service
#
resource "aws_ecs_cluster" "ecs" {
  name = "${var.system}-${var.env}-cluster"
}
