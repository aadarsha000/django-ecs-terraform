resource "aws_cloudwatch_log_group" "django_logs" {
  name              = "/ecs/${var.cluster_name}/${var.django_service_name}"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "celery_logs" {
  name              = "/ecs/${var.cluster_name}/${var.celery_service_name}"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "flower_logs" {
  name              = "/ecs/${var.cluster_name}/${var.flower_service_name}"
  retention_in_days = 30
  tags              = var.tags
}

// ECS CPU Utilization Alarm for Django
resource "aws_cloudwatch_metric_alarm" "django_high_cpu" {
  alarm_name                = "${var.cluster_name}-${var.django_service_name}-HighCPU"
  alarm_description         = "Alarm when Django service CPU > 80%"
  namespace                 = "AWS/ECS"
  metric_name               = "CPUUtilization"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 2
  threshold                 = 80
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.django_service_name
  }
  alarm_actions             = var.alarm_actions
  tags                      = var.tags
}

// ECS Memory Utilization Alarm for Celery
resource "aws_cloudwatch_metric_alarm" "celery_high_memory" {
  alarm_name                = "${var.cluster_name}-${var.celery_service_name}-HighMemory"
  alarm_description         = "Alarm when Celery service Memory > 75%"
  namespace                 = "AWS/ECS"
  metric_name               = "MemoryUtilization"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 2
  threshold                 = 75
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.celery_service_name
  }
  alarm_actions             = var.alarm_actions
  tags                      = var.tags
}

// RDS Free Storage Space Alarm
resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name                = "${var.rds_instance_identifier}-LowStorage"
  alarm_description         = "Alarm when RDS free storage space < 10 GB"
  namespace                 = "AWS/RDS"
  metric_name               = "FreeStorageSpace"
  statistic                 = "Minimum"
  period                    = 300
  evaluation_periods        = 1
  threshold                 = 10737418240  // 10 GB in bytes
  comparison_operator       = "LessThanOrEqualToThreshold"
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }
  alarm_actions             = var.alarm_actions
  tags                      = var.tags
}

// Redis Evictions Alarm
resource "aws_cloudwatch_metric_alarm" "redis_evictions" {
  alarm_name                = "${var.redis_replication_group_id}-Evictions"
  alarm_description         = "Alarm when Redis evictions > 0"
  namespace                 = "AWS/ElastiCache"
  metric_name               = "Evictions"
  statistic                 = "Sum"
  period                    = 300
  evaluation_periods        = 1
  threshold                 = 1
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  dimensions = {
    CacheClusterId = var.redis_replication_group_id
  }
  alarm_actions             = var.alarm_actions
  tags                      = var.tags
}

// Read Replica Lag Monitoring
resource "aws_cloudwatch_metric_alarm" "read_replica_lag" {
  count = var.read_replica_count

  alarm_name          = "${var.rds_instance_identifier}-replica-${count.index + 1}-lag"
  alarm_description   = "Alarm when read replica lag > 30 seconds"
  namespace           = "AWS/RDS"
  metric_name         = "ReplicaLag"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 30
  comparison_operator = "GreaterThanThreshold"
  
  dimensions = {
    DBInstanceIdentifier = var.read_replica_identifiers[count.index]
  }
  
  alarm_actions = var.alarm_actions
  tags          = var.tags
}

// Read Replica CPU Utilization
resource "aws_cloudwatch_metric_alarm" "read_replica_cpu" {
  count = var.read_replica_count

  alarm_name          = "${var.rds_instance_identifier}-replica-${count.index + 1}-high-cpu"
  alarm_description   = "Alarm when read replica CPU > 80%"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  
  dimensions = {
    DBInstanceIdentifier = var.read_replica_identifiers[count.index]
  }
  
  alarm_actions = var.alarm_actions
  tags          = var.tags
}

// Read Replica Connection Count
resource "aws_cloudwatch_metric_alarm" "read_replica_connections" {
  count = var.read_replica_count

  alarm_name          = "${var.rds_instance_identifier}-replica-${count.index + 1}-high-connections"
  alarm_description   = "Alarm when read replica connections > 400"
  namespace           = "AWS/RDS"
  metric_name         = "DatabaseConnections"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 400
  comparison_operator = "GreaterThanThreshold"
  
  dimensions = {
    DBInstanceIdentifier = var.read_replica_identifiers[count.index]
  }
  
  alarm_actions = var.alarm_actions
  tags          = var.tags
}