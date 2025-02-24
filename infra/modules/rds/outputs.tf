output "endpoint" {
  description = "The connection endpoint without port"
  value       = replace(aws_db_instance.kooben_db.endpoint, ":5432", "")
}

output "database_name" {
  description = "The name of the database"
  value       = aws_db_instance.kooben_db.db_name
}

output "username" {
  description = "The master username for the database"
  value       = aws_db_instance.kooben_db.username
}

output "port" {
  description = "The port the database is listening on"
  value       = aws_db_instance.kooben_db.port
} 