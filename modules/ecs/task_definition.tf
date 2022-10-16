data "aws_ecs_task_definition" "helloworld" {
  task_definition = aws_ecs_task_definition.helloworld.arn
}

resource "aws_ecs_task_definition" "helloworld" {
  family = "${var.app-name}-${var.env-short}-family"
  container_definitions    = data.template_file.task_definitions.rendered
  task_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "1024"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "${var.app-name}-${var.env-short}-family"
  }
}

data "template_file" "task_definitions" {
  template = "${file("task-definitions/registry.json")}"

  vars = {
    container_name  = "${var.app-name}-${var.env-short}-family"
    aws_id          = data.aws_caller_identity.current.account_id
    repository_name = aws_ecr_repository.helloworld.name
  }
}

