variable "domain_name" {
  description = "The full domain to secure and point (e.g. api.winx22.com)"
  type        = string
}

variable "zone_name" {
  description = "The Route53 hosted zone (must include trailing dot, e.g. winx22.com.)"
  type        = string
}

variable "record_name" {
  description = "The subdomain label to create in Route53 (e.g. 'api' for api.winx22.com)"
  type        = string
}

variable "target_dns_name" {
  description = "The DNS name of the alias target (e.g. your ALB DNS name)"
  type        = string
}

variable "target_zone_id" {
  description = "The Route53 zone ID of the alias target (e.g. your ALB zone ID)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all created resources"
  type        = map(string)
  default     = {}
}