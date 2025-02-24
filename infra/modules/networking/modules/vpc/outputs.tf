output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.kooben_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.kooben_public_subnet.id
}

output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.kooben_private_subnet_1.id
}

output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.kooben_private_subnet_2.id
}

output "public_subnet_2_id" {
  value = aws_subnet.kooben_public_subnet_2.id
} 