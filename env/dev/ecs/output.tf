output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_ec2_name" {
  value = module.ecs.service_ec2_name
}

output "alb_listner_arn" {
  value = module.ecs.listner_arn
}

output "alb_target_group_blue_name" {
  value = module.ecs.target_group_blue_name
}

output "alb_target_group_green_name" {
  value = module.ecs.target_group_green_name
}