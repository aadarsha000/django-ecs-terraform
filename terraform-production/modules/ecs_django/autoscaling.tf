resource "aws_appautoscaling_target" "django" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.django.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.django]
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${var.cluster_name}-cpu-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.django.resource_id
  scalable_dimension = aws_appautoscaling_target.django.scalable_dimension
  service_namespace  = aws_appautoscaling_target.django.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value               = var.cpu_target_value
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 120
    scale_out_cooldown = 60
  }
}