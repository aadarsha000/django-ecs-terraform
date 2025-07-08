variable "subnet_ids" {
  description = "Private subnets for Redis"
  type        = list(string)
}

variable "node_type" {
  description = "Instance type for Redis nodes (e.g., cache.t3.micro)"
  type        = string
}

variable "replicas_per_node_group" {
  description = "Number of replicas per node group (1 recommended for HA)"
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "Name of the Redis parameter group"
  type        = string
  default     = "default.redis7"
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

variable "port" {
  description = "Port to use for Redis"
  type        = number
  default     = 6379
}

variable "security_group_ids" {
  description = "Security groups to attach"
  type        = list(string)
}
