variable "cluster_name" {
  description = "Name of the ECS cluster (for resource naming)"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID where Flower service will run"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task IAM role for application permissions"
  type        = string
}

variable "app_image" {
  description = "Docker image URI for the Flower monitoring container"
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

variable "alb_target_group_arn" {
  description = "Target Group ARN if Flower is to be fronted by ALB"
  type        = string
}

variable "container_port" {
  description = "Port on which Flower listens"
  type        = number
  default     = 5555
}

variable "aws_region" {
  description = "AWS region for logs and services"
  type        = string
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
  description = "Database password (sensitive)"
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

variable "fargate_cpu" {
  type = string
  default = "256"
}

variable "fargate_memory" {
  type = string
  default = "512"
}

variable "debug" {
  description = "True for local or testing false for production"
  type = bool
  default = false
}

variable "postgres_read_hosts" {
  description = "Comma-separated list of read replica endpoints"
  type        = string
  default     = ""
}

variable "postgres_read_count" {
  description = "Number of read replicas available"
  type        = number
  default     = 0
}