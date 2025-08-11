resource "aws_db_subnet_group" "this" {
  name       = "${var.tags["Environment"]}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "random_password" "db_password" {
  count            = var.rds_password == "" ? 1 : 0
  length           = 20
  special          = true
  override_special = "!#$%^&*()-_=+[]{}|;:,.<>?"
}

locals {
  db_password = var.rds_password != "" ? var.rds_password : random_password.db_password[0].result
}

# Enhanced parameter group for master
resource "aws_db_parameter_group" "master" {
  family = "${var.engine}${split(".", var.engine_version)[0]}"
  name   = "${var.name_prefix}-master-params"

  # Optimized parameters for master (write-heavy)
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "log_statement"
    value = "mod"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "max_connections"
    value = "500"
  }

  parameter {
    name  = "work_mem"
    value = "16384"
  }

  parameter {
    name  = "maintenance_work_mem"
    value = "2097152"
  }

  parameter {
    name  = "effective_cache_size"
    value = "12582912"
  }

  parameter {
    name  = "random_page_cost"
    value = "1.1"
  }

  tags = var.tags
}

# Parameter group for read replicas
resource "aws_db_parameter_group" "replica" {
  count  = var.create_read_replicas ? 1 : 0
  family = "${var.engine}${split(".", var.engine_version)[0]}"
  name   = "${var.name_prefix}-replica-params"

  # Optimized parameters for read replicas (read-heavy)
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "log_statement"
    value = "none"
  }

  parameter {
    name  = "max_connections"
    value = "1000"
  }

  parameter {
    name  = "work_mem"
    value = "8192"
  }

  parameter {
    name  = "effective_cache_size"
    value = "12582912"
  }

  parameter {
    name  = "random_page_cost"
    value = "1.1"
  }

  parameter {
    name  = "hot_standby"
    value = "on"
  }

  parameter {
    name  = "max_standby_streaming_delay"
    value = "30s"
  }

  tags = var.tags
}

# Master RDS Instance
resource "aws_db_instance" "this" {
  identifier              = var.name_prefix
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  iops                    = var.iops
  db_name                 = var.db_name
  username                = var.username
  password                = local.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  parameter_group_name    = aws_db_parameter_group.master.name
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  publicly_accessible     = false
  apply_immediately       = false

  # Enable automated backups for read replica creation
  backup_window = "03:00-04:00"
  maintenance_window = "sun:04:00-sun:05:00"

  # Performance monitoring
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring[0].arn

  # Enable encryption
  storage_encrypted = true

  tags = merge(
    var.tags,
    { 
      Name = "${var.name_prefix}-master"
      Role = "master"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Read Replicas
resource "aws_db_instance" "read_replica" {
  count = var.create_read_replicas ? var.read_replica_count : 0

  identifier             = "${var.name_prefix}-replica-${count.index + 1}"
  replicate_source_db    = aws_db_instance.this.identifier
  instance_class         = var.read_replica_instance_class
  allocated_storage      = var.read_replica_allocated_storage
  storage_type           = var.read_replica_storage_type
  iops                   = var.read_replica_iops
  parameter_group_name   = aws_db_parameter_group.replica[0].name
  multi_az               = var.read_replica_multi_az
  publicly_accessible    = false
  auto_minor_version_upgrade = var.read_replica_auto_minor_version_upgrade
  backup_retention_period = var.read_replica_backup_retention_period

  # Distribute across AZs if specified
  availability_zone = length(var.read_replica_availability_zones) > 0 ? var.read_replica_availability_zones[count.index % length(var.read_replica_availability_zones)] : null

  # Performance monitoring
  performance_insights_enabled = var.read_replica_performance_insights_enabled
  performance_insights_retention_period = 7
  monitoring_interval = var.read_replica_monitoring_interval
  monitoring_role_arn = aws_iam_role.rds_monitoring[0].arn

  tags = merge(
    var.tags,
    { 
      Name = "${var.name_prefix}-replica-${count.index + 1}"
      Role = "read-replica"
      ReplicaIndex = count.index + 1
    }
  )

  depends_on = [aws_db_instance.this]

  lifecycle {
    create_before_destroy = true
  }
}

# IAM role for enhanced monitoring
resource "aws_iam_role" "rds_monitoring" {
  count = var.create_read_replicas ? 1 : 0
  name  = "${var.name_prefix}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  count      = var.create_read_replicas ? 1 : 0
  role       = aws_iam_role.rds_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}