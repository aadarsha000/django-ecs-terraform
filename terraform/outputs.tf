output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.network.private_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = module.ecs.ecs_service_name
}

output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = module.ecs.ecs_cluster_id
}