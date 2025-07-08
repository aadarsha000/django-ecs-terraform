variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "alb_http_port" {
  description = "Port for ALB HTTP traffic"
  type        = number
  default     = 80
}

variable "alb_https_port" {
  description = "Port for ALB HTTPS traffic"
  type        = number
  default     = 443
}

variable "alb_ingress_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "container_port" {
  description = "Port the ECS container (Django) is listening on"
  type        = number
  default     = 8000
}


variable "rds_port" {
  description = "Port for RDS database access"
  type        = number
  default     = 5432  # PostgreSQL default
}

variable "redis_port" {
  description = "Port for redis"
  type        = number
  default     = 6379
}

variable "flower_port" {
  description = "Port for flower"
  type        = number
  default     = 5555
}