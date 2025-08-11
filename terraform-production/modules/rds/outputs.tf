output "db_instance_endpoint" {
  description = "The connection endpoint for the master RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "The port on which the RDS instance is listening"
  value       = aws_db_instance.this.port
}

output "db_password" {
  description = "Master password for the RDS instance"
  value       = local.db_password
  sensitive   = true
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "instance_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.this.id
}

# Read replica outputs
output "read_replica_endpoints" {
  description = "List of read replica endpoints"
  value       = aws_db_instance.read_replica[*].address
}

output "read_replica_identifiers" {
  description = "List of read replica identifiers"
  value       = aws_db_instance.read_replica[*].id
}

output "read_replica_count" {
  description = "Number of read replicas created"
  value       = length(aws_db_instance.read_replica)
}

# Connection strings for different use cases
output "master_connection_string" {
  description = "Master database connection string (write operations)"
  value       = "postgresql://${aws_db_instance.this.username}:${local.db_password}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${aws_db_instance.this.db_name}"
  sensitive   = true
}

output "read_replica_connection_strings" {
  description = "Read replica connection strings (read operations)"
  value = [
    for replica in aws_db_instance.read_replica :
    "postgresql://${aws_db_instance.this.username}:${local.db_password}@${replica.address}:${replica.port}/${aws_db_instance.this.db_name}"
  ]
  sensitive = true
}

# For load balancer configuration
output "all_db_endpoints" {
  description = "All database endpoints (master + replicas)"
  value = concat(
    [aws_db_instance.this.address],
    aws_db_instance.read_replica[*].address
  )
}

# Monitoring outputs
output "master_performance_insights_enabled" {
  description = "Whether Performance Insights is enabled for master"
  value       = aws_db_instance.this.performance_insights_enabled
}

output "replica_performance_insights_enabled" {
  description = "Whether Performance Insights is enabled for replicas"
  value       = var.read_replica_performance_insights_enabled
}