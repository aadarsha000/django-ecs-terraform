variable "subnet_ids" {
  description = "Private subnets for RDS"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "VPC Security Group IDs"
  type        = list(string)
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "Instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Storage in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "django_db"
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "django_user"
}

variable "rds_password" {
  description = "Master password (if empty, will generate)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip snapshot before deletion"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Prefix for RDS identifier"
  type        = string
  default     = "django-db"
}
