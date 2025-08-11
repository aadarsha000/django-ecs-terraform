variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of AZs for subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "alb_ingress_cidrs" {
  description = "Allowed CIDRs to reach the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "fargate_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 2048
}

variable "fargate_memory" {
  description = "Fargate task memory (MB)"
  type        = number
  default     = 4096
}

variable "app_image" {
  description = "ECR image URI for the Django app"
  type        = string
  default     = "343218218445.dkr.ecr.ap-south-1.amazonaws.com/simple-web-app:prod"
}

variable "postgres_db" {
  description = "Name of the RDS database"
  type        = string
  default     = "django_db"
}

variable "postgres_user" {
  description = "RDS master username"
  type        = string
  default     = "django_user"
}

variable "postgres_password_secret_arn" {
  description = "ARN of the Secrets Manager secret for the DB password"
  type        = string
  default     = "arn:aws:secretsmanager:ap-south-1:343218218445:secret:prod/django-db-creds-l05sRl"
}

variable "alarm_sns_topic_arns" {
  description = "SNS topic ARNs for CloudWatch alarm actions"
  type        = list(string)
  default     = []
}

variable "rds_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

variable "redis_node_type" {
  description = "ElastiCache node type (e.g., cache.t3.micro)"
  type        = string
  default     = "cache.t3.micro"
}

variable "rds_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.r6g.xlarge"
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GB for the RDS instance"
  type        = number
  default     = 1024
}

variable "rds_storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
  default     = "io2"
}

variable "rds_iops" {
  description = "IOPS for the RDS instance"
  type        = number
  default     = 3000
}

variable "flower_port" {
  description = "Flower monitoring port"
  type        = number
  default     = 5555
}

variable "s3_block_public_access" {
  description = "Block-public-access settings for the S3 bucket"
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}


variable "enable_https" {
  description = "Whether to enable HTTPS on the ALB"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Custom domain for HTTPS (if enabled)"
  type        = string
  default     = ""
}

variable "ecs_django_desired_count" {
  description = "Initial number of Django tasks"
  type        = number
  default     = 2
}

variable "ecs_django_min_capacity" {
  description = "Min Django tasks for autoscaling"
  type        = number
  default     = 10
}

variable "ecs_django_max_capacity" {
  description = "Max Django tasks for autoscaling"
  type        = number
  default     = 100
}

variable "ecs_django_cpu_target" {
  description = "CPU % target for Django autoscaling"
  type        = number
  default     = 70
}

variable "ecs_celery_desired_count" {
  description = "Initial Celery worker count"
  type        = number
  default     = 1
}

variable "ecs_celery_min_capacity" {
  description = "Min Celery tasks for autoscaling"
  type        = number
  default     = 20
}

variable "ecs_celery_max_capacity" {
  description = "Max Celery tasks for autoscaling"
  type        = number
  default     = 200
}

variable "ecs_celery_memory_target" {
  description = "Memory % target for Celery autoscaling"
  type        = number
  default     = 75
}
