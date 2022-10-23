output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_ec2_name" {
  value = aws_ecs_service.frontend_ec2.name
}