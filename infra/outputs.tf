# S3 Outputs
output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.myBucket.bucket_arn
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.myBucket.bucket_name
}

output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.myBucket.bucket_id
}

# Security Groups Outputs
output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = module.security_groups.backend_security_group_id
}

output "frontend_security_group_id" {
  description = "ID of the frontend security group"
  value       = module.security_groups.frontend_security_group_id
} 