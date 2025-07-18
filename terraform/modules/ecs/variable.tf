variable "cluster_name" {
  type = string
}

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

variable "container_port" {
  type = number
}

variable "private_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "max_capacity" {
  type    = number
  default = 3
}

variable "cpu_target_value" {
  type        = number
  description = "Target CPU utilization percentage for scaling"
  default     = 70
}

variable "aws_region" {
  type = string
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

variable "aws_storage_bucket_name" {
  type = string
}

variable "aws_s3_region_name" {
  type = string
}

variable "aws_s3_custom_domain" {
  type = string
}


variable "celery_broker_url" {
  type = string
}
