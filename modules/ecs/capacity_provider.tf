###
#
# Capacity Provider
#
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name  = "${var.system}-${var.env}-ecs-optimized"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_optimized.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.asg_target_capacity
    }
  }
}