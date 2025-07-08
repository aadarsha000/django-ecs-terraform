variable "fargate_cpu" {
  type = string
}

variable "fargate_memory" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "app_image" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "aws_region" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "cluster_name" {
  description = "ECS Cluster name (for scaling resource ID)"
  type        = string
}

variable "desired_count" {
  type = number
}

variable "min_capacity" {
  description = "Minimum number of Celery tasks"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of Celery tasks"
  type        = number
  default     = 10
}

variable "memory_target_value" {
  description = "Target MemoryUtilization percentage for scaling"
  type        = number
  default     = 75
}

variable "postgres_db" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "postgres_host" {
  type = string
}

variable "postgres_port" {
  type = string
}
