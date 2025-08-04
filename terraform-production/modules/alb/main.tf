// 1) ALB itself
resource "aws_lb" "this" {
  name               = "${var.tags["Environment"]}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = var.tags
}

// 2) Target group for your Django app
resource "aws_lb_target_group" "django" {
  name        = "${var.tags["Environment"]}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  tags = var.tags
}

// 3) HTTP → HTTPS redirect (if HTTPS enabled)
resource "aws_lb_listener" "http_redirect" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }

  tags = var.tags
}

// 4) HTTP → forward (if HTTPS disabled)
resource "aws_lb_listener" "http_forward" {
  count             = var.enable_https ? 0 : 1
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django.arn
  }

  tags = var.tags
}

// 5) ACM Certificate + DNS validation (only if HTTPS)
resource "aws_acm_certificate" "cert" {
  count             = var.enable_https ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
}

data "aws_route53_zone" "zone" {
  count        = var.enable_https ? 1 : 0
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "validation" {
  for_each = var.enable_https ? {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = data.aws_route53_zone.zone[0].id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert_val" {
  count                      = var.enable_https ? 1 : 0
  certificate_arn            = aws_acm_certificate.cert[0].arn
  validation_record_fqdns    = values(aws_route53_record.validation)[*].fqdn
}

// 6) HTTPS listener (only once cert is validated)
resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  depends_on        = [aws_acm_certificate_validation.cert_val]
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django.arn
  }

  tags = var.tags
}

// 7) Route53 alias for api.yoursite.com → ALB (only if HTTPS)
resource "aws_route53_record" "alias" {
  count   = var.enable_https ? 1 : 0
  zone_id = data.aws_route53_zone.zone[0].id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}