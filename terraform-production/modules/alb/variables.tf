variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB will live"
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for the ALB"
}
variable "alb_security_group_id" {
  type        = string
  description = "Security Group for the ALB"
}
variable "container_port" {
  type        = number
  description = "Port the ECS container listens on"
}
variable "health_check_path" {
  type        = string
  description = "Path for ALB health checks"
  default     = "/health/"
}
variable "enable_https" {
  type        = bool
  description = "Whether to provision ACM + enable HTTPS listener"
  default     = false
}
variable "domain_name" {
  type        = string
  description = "FQDN to secure & route (e.g. api.winx22.com)"
  default     = ""
}
variable "zone_name" {
  type        = string
  description = "Route53 hosted zone name (must include trailing dot, e.g. winx22.com.)"
  default     = ""
}
variable "record_name" {
  type        = string
  description = "Record label (e.g. 'api' for api.winx22.com)"
  default     = ""
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
