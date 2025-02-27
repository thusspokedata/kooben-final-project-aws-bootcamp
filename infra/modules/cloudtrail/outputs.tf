output "cloudtrail_id" {
  description = "The name of the CloudTrail trail"
  value       = aws_cloudtrail.kooben_trail.id
}

output "cloudtrail_arn" {
  description = "The ARN of the CloudTrail trail"
  value       = aws_cloudtrail.kooben_trail.arn
}

output "cloudtrail_s3_bucket_name" {
  description = "The name of the S3 bucket where CloudTrail logs are stored"
  value       = var.existing_s3_bucket_name
}

output "cloudtrail_cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch log group where CloudTrail logs are delivered"
  value       = aws_cloudwatch_log_group.cloudtrail_logs.arn
}

output "cloudtrail_kms_key_id" {
  description = "The ID of the KMS key used for CloudTrail logs encryption"
  value       = local.kms_key_id
}

output "is_using_external_kms_key" {
  description = "Whether CloudTrail is using an external KMS key"
  value       = var.kms_key_id != ""
} 