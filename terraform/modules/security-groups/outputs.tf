output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "Security Group ID for ECS Django"
  value       = aws_security_group.ecs_django.id
}

output "ecs_celery_sg_id" {
  description = "Security Group ID for ECS Celery"
  value       = aws_security_group.ecs_celery.id
}

output "ecs_flower_sg_id" {
  description = "Security Group ID for ECS Flower"
  value       = aws_security_group.ecs_flower.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS"
  value       = aws_security_group.rds.id
}

output "redis_security_group_id" {
  description = "Security Group ID for Elasticache Redis"
  value       = aws_security_group.elasticache.id
}
