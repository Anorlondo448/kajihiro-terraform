###
#
# Elastic Container Registry
#
resource "aws_ecr_repository" "frontend" {
  name                 = "${var.system}-${var.env}-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}