resource "aws_ecs_task_definition" "flower_task" {
  family                   = "flower-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "flower"
      image     = var.app_image
      essential = true

      portMappings = [
        {
          containerPort = 5555
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "RUN_MODE", value = "flower" },
        { name = "DJANGO_SETTINGS_MODULE", value = "core.settings" },
        { name = "POSTGRES_DB", value = var.postgres_db },
        { name = "POSTGRES_USER", value = var.postgres_user },
        { name = "POSTGRES_PASSWORD", value = var.postgres_password },
        { name = "POSTGRES_HOST", value = var.postgres_host },
        { name = "POSTGRES_PORT", value = var.postgres_port }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/flower"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "flower"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:5555/ || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}
