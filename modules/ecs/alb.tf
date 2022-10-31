###
#
# Application Load Balancer
#
resource "aws_lb" "public" {
  name               = "${var.system}-${var.env}-public"
  internal           = false
  load_balancer_type = "application"
  subnets         = var.subnet_public_id
  security_groups = [var.security_group_id_allow_http_from_any]

  enable_deletion_protection = false

  tags = {
    Name = "${var.system}-${var.env}"
  }
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public-blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}

resource "aws_lb_listener_rule" "public" {
  listener_arn = aws_lb_listener.public.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public-blue.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  lifecycle {
    ignore_changes = [
      action[0].target_group_arn,
    ]
  }
}
resource "aws_lb_target_group" "public-blue" {
  name     = "${var.system}-${var.env}-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 80
    path = "/"
  }
}

resource "aws_lb_target_group" "public-green" {
  name     = "${var.system}-${var.env}-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 80
    path = "/"
  }
}
