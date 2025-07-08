resource "aws_ecs_task_definition" "celery_task" {
  family                   = "celery-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "celery"
      image     = var.app_image
      essential = true

      environment = [
        {"name": "RUN_MODE", "value": "celery"},
        { "name": "DJANGO_SETTINGS_MODULE", "value": "core.settings" },
        { "name": "POSTGRES_DB", "value": var.postgres_db },
        { "name": "POSTGRES_USER", "value": var.postgres_user },
        { "name": "POSTGRES_PASSWORD", "value": var.postgres_password },
        { "name": "POSTGRES_HOST", "value": var.postgres_host },
        { "name": "POSTGRES_PORT", "value": var.postgres_port }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/celery"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "celery"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "celery_service" {
  name            = "celery-service"
  cluster         = var.cluster_id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.celery_task.arn

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  tags = {
    Environment = "production"
  }
}

resource "aws_appautoscaling_target" "celery" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.celery_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "celery_memory_policy" {
  name               = "celery-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.celery.resource_id
  scalable_dimension = aws_appautoscaling_target.celery.scalable_dimension
  service_namespace  = aws_appautoscaling_target.celery.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.memory_target_value
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_in_cooldown  = 120
    scale_out_cooldown = 60
  }
}
