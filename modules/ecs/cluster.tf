###
#
# Elastic Container Service
#
resource "aws_ecs_cluster" "main" {
  name = "${var.system}-${var.env}-cluster"
}

# ASG
resource "aws_ecs_cluster_capacity_providers" "asg" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

# # Fargate
# resource "aws_ecs_cluster_capacity_providers" "fargate" {
#   cluster_name = aws_ecs_cluster.main.name

#   capacity_providers = [
#     "FARGATE",
#     "FARGATE_SPOT"
#   ]

#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE"
#     weight            = 90
#   }
#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#     weight            = 10
#   }
# }