output "ec2_role_id" {
  description = "ID of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.id
}

output "ec2_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "cloudtrail_cloudwatch_role_arn" {
  description = "ARN of the CloudTrail CloudWatch role"
  value       = aws_iam_role.cloudtrail_cloudwatch_role.arn
}

output "cloudtrail_cloudwatch_role_id" {
  description = "ID of the CloudTrail CloudWatch role"
  value       = aws_iam_role.cloudtrail_cloudwatch_role.id
} 