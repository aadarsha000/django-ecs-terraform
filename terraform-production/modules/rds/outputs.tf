output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
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
