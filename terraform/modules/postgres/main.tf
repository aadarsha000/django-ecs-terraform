# --- Database Subnet Group
resource "aws_db_subnet_group" "rds" {
    name = "rds-subnets-group"
    subnet_ids = var.subnet_ids
    tags = {
        Name = "rds-subnet-group"
    }
}

# --- Database Password
resource "random_password" "db_password" {
  count            = var.rds_password == "" ? 1 : 0
  length           = 20
  special          = true
  override_special = "!#$%^&*()-_=+[]{}|;:,.<>?"
}

locals {
  db_password = var.rds_password != "" ? var.rds_password : random_password.db_password[0].result
}

# --- RDS Database Instance
resource "aws_db_instance" "db_main" {
  identifier              = var.name_prefix
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = "gp3"
  db_name                 = var.db_name
  username                = var.username
  password                = local.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  parameter_group_name    = "default.postgres${split(".", var.engine_version)[0]}"
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  publicly_accessible     = false #true
  apply_immediately       = false

  tags = { 
    Name = "rds"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_db_subnet_group.rds]
}