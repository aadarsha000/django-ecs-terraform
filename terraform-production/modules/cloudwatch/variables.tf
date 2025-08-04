variable "cluster_name" {
  description = "Name of the ECS cluster for alarms"
  type        = string
}

variable "django_service_name" {
  description = "Name of the ECS Django service"
  type        = string
}

variable "celery_service_name" {
  description = "Name of the ECS Celery service"
  type        = string
}

variable "flower_service_name" {
  description = "Name of the ECS Flower service"
  type        = string
}

variable "rds_instance_identifier" {
  description = "Identifier of the RDS instance"
  type        = string
}

variable "redis_replication_group_id" {
  description = "Replication group ID of the Redis cluster"
  type        = string
}

variable "alarm_actions" {
  description = "List of SNS topic ARNs or other targets for alarm actions"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to all CloudWatch resources"
  type        = map(string)
}