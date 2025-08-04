output "vpc_id" {
  description = "The VPC ID"
  value       = module.network.vpc_id
}

output "cluster_id" {
  description = "ECS Cluster ID"
  value       = module.ecs_django.cluster_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "s3_bucket_name" {
  description = "S3 bucket for static assets"
  value       = module.s3.s3_bucket_name
}