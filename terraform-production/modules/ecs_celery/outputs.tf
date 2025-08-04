output "service_name" {
  description = "Name of the ECS Celery service"
  value       = aws_ecs_service.celery.name
}

output "task_definition_arn" {
  description = "ARN of the ECS Celery task definition"
  value       = aws_ecs_task_definition.celery.arn
}
