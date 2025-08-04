resource "aws_security_group" "alb" {
  name        = "${var.tags["Environment"]}-alb-sg"
  description = "Allow HTTP/HTTPS ingress to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.alb_http_port
    to_port     = var.alb_http_port
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  ingress {
    from_port   = var.alb_https_port
    to_port     = var.alb_https_port
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_django" {
  name        = "${var.tags["Environment"]}-ecs-django-sg"
  description = "Allow traffic from ALB to ECS Django tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_celery" {
  name        = "${var.tags["Environment"]}-ecs-celery-sg"
  description = "Allow outbound traffic for Celery workers"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_flower" {
  name        = "${var.tags["Environment"]}-ecs-flower-sg"
  description = "Allow access to Flower from ALB or internal network"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.flower_port
    to_port         = var.flower_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "rds" {
  name        = "${var.tags["Environment"]}-rds-sg"
  description = "Allow ECS tasks to access RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.rds_port
    to_port         = var.rds_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_django.id, aws_security_group.ecs_celery.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "elasticache" {
  name        = "${var.tags["Environment"]}-elasticache-sg"
  description = "Allow ECS tasks to access ElastiCache Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.redis_port
    to_port         = var.redis_port
    protocol        = "tcp"
    security_groups = [
      aws_security_group.ecs_django.id,
      aws_security_group.ecs_celery.id,
      aws_security_group.ecs_flower.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}