resource "aws_appautoscaling_target" "celery" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.celery.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.celery]
}

resource "aws_appautoscaling_policy" "memory" {
  name               = "${var.cluster_name}-celery-memory-policy"
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