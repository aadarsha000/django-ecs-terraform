variable "subnet_ids" {
  description = "Private subnet IDs for the RDS cluster"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach to the RDS instance"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for RDS identifier"
  type        = string
}

variable "engine" {
  description = "Database engine to use"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Version of the database engine"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "Instance class of the RDS instance"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "django_db"
}

variable "username" {
  description = "Master username for the database"
  type        = string
  default     = "django_user"
}

variable "rds_password" {
  description = "Master password for the database (leave empty to auto-generate)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on resource deletion"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection on the RDS instance"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to all RDS resources"
  type        = map(string)
}