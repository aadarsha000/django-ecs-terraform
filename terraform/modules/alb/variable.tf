variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "container_port" {
  description = "Port ECS container listens on (e.g., 8000)"
  type        = number
}

variable "alb_http_port" {
  description = "HTTP port for ALB listener (default 80)"
  type        = number
  default     = 80
}

variable "alb_https_port" {
  description = "HTTPS port for ALB listener (default 443)"
  type        = number
  default     = 443
}

variable "enable_https" {
  description = "Whether to enable HTTPS listener"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for ACM certificate (required if enable_https=true)"
  type        = string
  default     = ""
}

variable "health_check_path" {
  description = "Path for ALB health check (e.g., /health/)"
  type        = string
  default     = "/"
}
