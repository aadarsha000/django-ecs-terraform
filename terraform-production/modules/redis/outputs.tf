output "redis_primary_endpoint" {
  description = "Primary endpoint for Redis connections"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Read endpoint for Redis read replicas"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "redis_port" {
  description = "Port number for Redis"
  value       = aws_elasticache_replication_group.this.port
}

output "redis_auth_token" {
  description = "Redis authentication token (sensitive)"
  value       = random_password.auth_token.result
  sensitive   = true
}

output "replication_group_id" {
  description = "Redis replication group identifier"
  value       = aws_elasticache_replication_group.this.id
}
