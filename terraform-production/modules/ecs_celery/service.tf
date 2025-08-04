resource "aws_ecs_service" "celery" {
  name            = "${var.cluster_name}-celery-service"
  cluster         = var.cluster_id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.celery.arn

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  tags = var.tags
}