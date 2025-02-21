output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = module.roles.ec2_instance_profile_name
}

output "ec2_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = module.roles.ec2_role_arn
} 