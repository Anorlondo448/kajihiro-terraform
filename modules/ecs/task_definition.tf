###
#
# Task Definition
#
data "aws_caller_identity" "current" {}

data "aws_ecs_task_definition" "frontend" {
  task_definition = aws_ecs_task_definition.frontend.arn
}

resource "aws_ecs_task_definition" "frontend" {
  family = "${var.system}-${var.env}-family"
  container_definitions    = data.template_file.task_definitions.rendered
  task_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskRole"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "1024"
  requires_compatibilities = ["FARGATE"]

  tags = {
    Name = "${var.system}-${var.env}"
  }
}

data "template_file" "task_definitions" {
  template = "${file("../../../modules/ecs/task-definitions/registry.json")}"

  vars = {
    container_name  = "${var.system}-${var.env}-frontend"
    aws_id          = data.aws_caller_identity.current.account_id
    repository_name = var.repository_frontend
  }
}

