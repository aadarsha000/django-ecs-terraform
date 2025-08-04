variable "cluster_name" {
  description = "Name of the ECS cluster (for autoscaling resource ID)"
  type        = string
}

variable "cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "fargate_cpu" {
  description = "Fargate task CPU units"
  type        = number
}

variable "fargate_memory" {
  description = "Fargate task memory (MB)"
  type        = number
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role for application permissions"
  type        = string
}

variable "app_image" {
  description = "Docker image URI for the Celery worker"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for ECS tasks"
  type        = list(string)
}

variable "desired_count" {
  description = "Desired number of Celery worker tasks"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of Celery tasks for autoscaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of Celery tasks for autoscaling"
  type        = number
  default     = 10
}

variable "memory_target_value" {
  description = "Target MemoryUtilization percentage for scaling"
  type        = number
  default     = 75
}

variable "postgres_db" {
  description = "Database name for Django app"
  type        = string
}

variable "postgres_user" {
  description = "Database user for Django app"
  type        = string
}

variable "postgres_password" {
  description = "Database password for Django app"
  type        = string
  sensitive   = true
}

variable "postgres_host" {
  description = "Database host for Django app"
  type        = string
}

variable "postgres_port" {
  description = "Database port for Django app"
  type        = number
}

variable "aws_storage_bucket_name" {
  description = "S3 bucket name for static/media"
  type        = string
}

variable "aws_s3_region_name" {
  description = "Region for the S3 bucket"
  type        = string
}

variable "aws_s3_custom_domain" {
  description = "Custom domain for S3 static assets"
  type        = string
}

variable "celery_broker_url" {
  description = "URL for Celery broker (e.g., Redis)"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to all ECS resources"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region for logs"
  type        = string
}

variable "debug" {
  description = "True for local or testing false for production"
  type = bool
  default = false
}