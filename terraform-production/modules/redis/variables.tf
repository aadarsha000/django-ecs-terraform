variable "subnet_ids" {
  description = "Private subnet IDs for ElastiCache Redis"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs to attach to the Redis cluster"
  type        = list(string)
}

variable "node_type" {
  description = "ElastiCache node type (e.g., cache.t3.micro)"
  type        = string
}

variable "replicas_per_node_group" {
  description = "Number of read replicas per node group (1 recommended for HA)"
  type        = number
  default     = 1
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

variable "parameter_group_name" {
  description = "Name of the Redis parameter group"
  type        = string
  default     = "default.redis7"
}

variable "port" {
  description = "Port for Redis connections"
  type        = number
  default     = 6379
}

variable "tags" {
  description = "Map of tags to apply to Redis resources"
  type        = map(string)
}
