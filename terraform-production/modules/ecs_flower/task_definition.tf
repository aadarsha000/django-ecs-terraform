resource "aws_ecs_task_definition" "flower" {
  family                   = "${var.cluster_name}-flower-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "flower"
      image     = var.app_image
      essential = true
      portMappings = [
        { containerPort = var.container_port, protocol = "tcp" }
      ]
      environment = [
        { name = "RUN_MODE",               value = "flower" },
        { name = "DJANGO_SETTINGS_MODULE", value = "core.settings" },
        { name = "DEBUG",                         value = tostring(var.debug) },
        { name = "POSTGRES_DB",            value = var.postgres_db },
        { name = "POSTGRES_USER",          value = var.postgres_user },
        { name = "POSTGRES_PASSWORD",      value = var.postgres_password },
        { name = "POSTGRES_HOST",          value = var.postgres_host },
        { name = "POSTGRES_PORT",          value = tostring(var.postgres_port) },
        { name = "AWS_STORAGE_BUCKET_NAME",       value = var.aws_storage_bucket_name },
        { name = "AWS_S3_REGION_NAME",           value = var.aws_s3_region_name },
        { name = "AWS_S3_CUSTOM_DOMAIN",         value = var.aws_s3_custom_domain },
        { name = "CELERY_BROKER_URL",             value = var.celery_broker_url }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.cluster_name}/${var.cluster_name}-flower-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "${var.cluster_name}-flower-service"
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}/ || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = var.tags
}