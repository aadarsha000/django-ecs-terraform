output "service_name" {
  description = "Name of the ECS Flower service"
  value       = aws_ecs_service.flower.name
}

output "task_definition_arn" {
  description = "ARN of the ECS Flower task definition"
  value       = aws_ecs_task_definition.flower.arn
}