###
#
# Service
#
resource "aws_ecs_service" "frontend_ec2" {
  name             = "${var.system}-${var.env}-frontend"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.frontend.arn
  desired_count    = 1
  # platform_version = "1.4.0"

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.public-blue.arn
    container_name   = "${var.system}-${var.env}-frontend"
    container_port   = 80
  }

  network_configuration {
    subnets = var.subnet_public_id

    security_groups = [
      var.security_group_id_allow_http_from_any,
    ]
  }

  depends_on = [
    aws_lb.public,
  ]

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      capacity_provider_strategy
    ]
  }
}
