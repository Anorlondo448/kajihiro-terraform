output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_ec2_name" {
  value = aws_ecs_service.frontend_ec2.name
}

output "listner_arn" {
  value = aws_lb_listener.public.arn
}

output "target_group_blue_name" {
  value = aws_lb_target_group.public-blue.name
}

output "target_group_green_name" {
  value = aws_lb_target_group.public-green.name
}