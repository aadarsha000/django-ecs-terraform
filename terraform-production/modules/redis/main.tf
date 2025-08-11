resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.tags["Environment"]}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "random_password" "auth_token" {
  length           = 32
  special          = false
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.tags["Environment"]}-redis-repl"
  description                   = "Redis replication group for ${var.tags["Environment"]}"
  node_type                     = var.node_type
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group_name
  port                          = var.port
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = var.security_group_ids

  automatic_failover_enabled    = var.replicas_per_node_group > 0
  num_node_groups               = var.num_shards
  replicas_per_node_group       = var.replicas_per_node_group
  multi_az_enabled              = var.replicas_per_node_group > 0

  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  auth_token                    = random_password.auth_token.result

  snapshot_retention_limit      = 7
  snapshot_window               = "05:00-06:00"
  maintenance_window            = "sun:03:00-sun:04:00"

  tags = var.tags
}
