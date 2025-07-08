output "ecs_service_name" {
  value = aws_ecs_service.celery_service.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.celery_task.arn
}
