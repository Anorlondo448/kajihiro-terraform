###
#
# CodeCommit
#
resource "aws_codecommit_repository" "frontend" {
  repository_name = "${var.system}-${var.env}-frontend"
  description     = "${var.system}-${var.env}-frontend-repository"
}