output "db_instance_endpoint" {
  description = "DNS endpoint of the RDS instance"
  value       = aws_db_instance.db_main.address
}

output "db_instance_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.db_main.port
}

output "db_password" {
  description = "RDS password (either provided or generated)"
  value       = local.db_password
  sensitive   = true
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.db_main.db_name
}
