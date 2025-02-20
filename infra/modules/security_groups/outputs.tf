output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.sg_backend.id
}

output "frontend_security_group_id" {
  description = "ID of the frontend security group"
  value       = aws_security_group.sg_frontend.id
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.sg_database.id
}