# ALB

resource "aws_lb" "alb" {
  internal = false
  load_balancer_type = "application"
  security_groups = [var.alb_security_group_id]
  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "alb"
  }
}

resource "aws_lb_target_group" "django" {
  port = var.container_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    path     = var.health_check_path
    protocol = "HTTP"
    matcher = "200"
    timeout = 10
    interval = 150
    healthy_threshold = 2
    unhealthy_threshold = 5
  }

  tags = {
    Name = "lb-tg-django"
  }
}

# Listener: HTTP
resource "aws_lb_listener" "http" {
  count = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port = var.alb_http_port
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags={
    Name = "listener-http"
  }
}

resource "aws_lb_listener" "http_plain" {
  count             = var.enable_https ? 0 : 1
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django.arn
  }

  tags={
    Name = "listener-http-plain"
  }
}

# Certificate for HTTPS
resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "app-cert"
  }
}

# Listener: Https
resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # Recommended default
  certificate_arn   = aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django.arn
  }

  tags = {
    Name = "-alb-https-listener"  
  }
  
}