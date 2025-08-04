output "django_log_group" {
  description = "CloudWatch Log Group for Django ECS"
  value       = aws_cloudwatch_log_group.django_logs.name
}

output "celery_log_group" {
  description = "CloudWatch Log Group for Celery ECS"
  value       = aws_cloudwatch_log_group.celery_logs.name
}

output "flower_log_group" {
  description = "CloudWatch Log Group for Flower ECS"
  value       = aws_cloudwatch_log_group.flower_logs.name
}