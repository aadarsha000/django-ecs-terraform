output "ecs_cluster_id" {
  value = aws_ecs_cluster.django_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.django_service.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.django_task.arn
}
