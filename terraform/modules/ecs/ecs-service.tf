resource "aws_ecs_service" "django_service" {
  name            = "django-service"
  cluster         = aws_ecs_cluster.django_cluster.id
  launch_type     = "FARGATE"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.django_task.arn

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "django"
    container_port   = 8000
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  tags = {
    Environment = "production"
  }
}
