###
#
# Auto Scaling Group
#
resource "aws_autoscaling_group" "ecs_optimized" {
  name                      = "${var.system}-${var.env}-ecs-optimized"
  max_size                  = 5
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = var.subnet_private_id

  launch_template {
    id      = aws_launch_template.ecs_optimized.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.system}-${var.env}"
    propagate_at_launch = true
  }
}