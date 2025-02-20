output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.kooben_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.kooben_public_subnet.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.kooben_private_subnet.id
} 