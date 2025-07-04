resource "aws_ecs_cluster" "django_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Environment = "production"
    Project     = "django"
    Name        = var.cluster_name
  }
}
