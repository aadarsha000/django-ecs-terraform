output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "Security Group ID for ECS Django"
  value       = aws_security_group.ecs_django.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS"
  value       = aws_security_group.rds.id
}
