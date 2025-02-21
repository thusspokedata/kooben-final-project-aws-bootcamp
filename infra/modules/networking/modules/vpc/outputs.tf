output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.kooben_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.kooben_public_subnet.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    aws_subnet.kooben_private_subnet_1.id,
    aws_subnet.kooben_private_subnet_2.id
  ]
} 