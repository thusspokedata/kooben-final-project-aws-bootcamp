output "sg_backend_id" {
  value = aws_security_group.sg_backend.id
}

output "sg_frontend_id" {
  value = aws_security_group.sg_frontend.id
}