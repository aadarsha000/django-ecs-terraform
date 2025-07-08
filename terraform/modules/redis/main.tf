resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "redis-subnet-group"
  }
}

resource "random_password" "auth_token" {
  length  = 32
  special = false
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "redis-repl-group"
  description                   = "Highly available Redis replication group"
  node_type                     = var.node_type
  num_node_groups               = 1
  replicas_per_node_group       = var.replicas_per_node_group # Typically 1 for HA
  automatic_failover_enabled    = var.replicas_per_node_group > 0 ? true : false
  multi_az_enabled              = var.replicas_per_node_group > 0 ? true : false
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group_name
  port                          = var.port
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = var.security_group_ids

  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  auth_token                    = random_password.auth_token.result

  maintenance_window            = "sun:03:00-sun:04:00"
  snapshot_retention_limit      = 7
  snapshot_window               = "03:00-04:00"

  tags = {
    Name = "redis-replication-group"
  }
}
