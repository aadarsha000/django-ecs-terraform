output "ecs_service_name" {
  value = aws_ecs_service.flower_service.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.flower_task.arn
}
