output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value  = aws_lb.alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value = aws_lb_target_group.django.arn
}
