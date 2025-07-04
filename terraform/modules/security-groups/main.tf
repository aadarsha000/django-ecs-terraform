resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.alb_http_port   # 80
    to_port     = var.alb_http_port
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs  # 0.0.0.0/0 → world
  }

  ingress {
    from_port   = var.alb_https_port  # 443
    to_port     = var.alb_https_port
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_security_group" "ecs_django" {
  vpc_id      = var.vpc_id
  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
    description = "Allow traffic from the ALB security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "ecs-django-sg"
  }
}

resource "aws_security_group" "rds" {
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_django.id]
    description = "Allow traffic from Django ECS security groups"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic (can be restricted further)"
  }

  tags = {
    Name = "ecs-rds-sg"
  }
}

