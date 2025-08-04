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

resource "aws_db_instance" "this" {
  identifier              = var.name_prefix
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = "gp3"
  db_name                 = var.db_name
  username                = var.username
  password                = local.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  parameter_group_name    = "default.${var.engine}${split(".", var.engine_version)[0]}"
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  publicly_accessible     = false
  apply_immediately       = false

  tags = merge(
    var.tags,
    { Name = var.name_prefix }
  )

  lifecycle {
    create_before_destroy = true
  }
}
