###
#
# CodeDeploy
#
# Application on EC2
resource "aws_codedeploy_app" "frontend" {
  compute_platform = "ECS"
  name             = "${var.system}-${var.env}-frontend"
}

# Deplouyment Group on EC2
resource "aws_codedeploy_deployment_group" "frontend" {
  app_name               = aws_codedeploy_app.frontend.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.system}-${var.env}-frontend"
  service_role_arn       = aws_iam_role.codedeploy_for_ecs.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_ec2_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listner_arn]
      }

      target_group {
        name = var.alb_target_group_blue_name
      }

      target_group {
        name = var.alb_target_group_green_name
      }
    }
  }
}

# Application on Fargate
resource "aws_codedeploy_app" "frontend_fargate" {
  compute_platform = "ECS"
  name             = "${var.system}-${var.env}-frontend-fargate"
}

# Deplouyment Group on Fargate
resource "aws_codedeploy_deployment_group" "frontend_fargate" {
  app_name               = aws_codedeploy_app.frontend_fargate.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.system}-${var.env}-frontend-fargate"
  service_role_arn       = aws_iam_role.codedeploy_for_ecs.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_fargate_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listner_arn]
      }

      target_group {
        name = var.alb_target_group_blue_name
      }

      target_group {
        name = var.alb_target_group_green_name
      }
    }
  }
}