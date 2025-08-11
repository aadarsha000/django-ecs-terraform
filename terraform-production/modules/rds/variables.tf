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

variable "storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
  default     = "gp3"
}

variable "iops" {
  description = "IOPS for the RDS instance"
  type        = number
  default     = null
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

variable "create_read_replicas" {
  description = "Whether to create read replicas"
  type        = bool
  default     = true
}

variable "read_replica_count" {
  description = "Number of read replicas to create"
  type        = number
  default     = 2
}

variable "read_replica_instance_class" {
  description = "Instance class for read replicas (can be smaller than master)"
  type        = string
  default     = "db.r6g.large"
}

variable "read_replica_storage_type" {
  description = "Storage type for read replicas"
  type        = string
  default     = "gp3"
}

variable "read_replica_iops" {
  description = "IOPS for read replicas"
  type        = number
  default     = null
}

variable "read_replica_allocated_storage" {
  description = "Allocated storage for read replicas (GB)"
  type        = number
  default     = 512
}

variable "read_replica_availability_zones" {
  description = "Availability zones for read replicas"
  type        = list(string)
  default     = []
}

variable "read_replica_multi_az" {
  description = "Enable Multi-AZ for read replicas"
  type        = bool
  default     = false
}

variable "read_replica_auto_minor_version_upgrade" {
  description = "Enable auto minor version upgrade for read replicas"
  type        = bool
  default     = true
}

variable "read_replica_backup_retention_period" {
  description = "Backup retention period for read replicas"
  type        = number
  default     = 0
}

variable "read_replica_performance_insights_enabled" {
  description = "Enable Performance Insights for read replicas"
  type        = bool
  default     = true
}

variable "read_replica_monitoring_interval" {
  description = "Enhanced monitoring interval for read replicas"
  type        = number
  default     = 60
}