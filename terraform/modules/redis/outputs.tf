output "redis_primary_endpoint" {
  description = "Primary endpoint to connect Redis"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Reader endpoint (for read replicas)"
  value       = aws_elasticache_replication_group.redis.reader_endpoint_address
}

output "redis_port" {
  description = "Redis port"
  value       = aws_elasticache_replication_group.redis.port
}

output "redis_auth_token" {
  description = "Redis authentication token (password)"
  value       = random_password.auth_token.result
  sensitive   = true
}
