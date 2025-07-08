variable "ecs_cluster_id" {
  type = string
}

variable "fargate_cpu" {
  type = string
  default = "256"
}

variable "fargate_memory" {
  type = string
  default = "512"
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

variable "alb_target_group_arn" {
  type = string
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
  type = string
  sensitive = true
}

variable "postgres_host" {
  type = string
}

variable "postgres_port" {
  type = string
}
