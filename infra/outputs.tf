# S3 Outputs
output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.myBucket.s3_bucket_arn
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.myBucket.s3_bucket_name
}

output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.myBucket.s3_bucket_id
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

output "backend_endpoint" {
  description = "The endpoint URL for the backend"
  value       = "http://${module.route53.backend_url}"
}

output "frontend_endpoint" {
  description = "The endpoint URL for the frontend"
  value       = "http://${module.route53.frontend_url}"
}

output "alb_dns" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
} 