output "shared_key_id" {
  description = "The ID of the shared KMS key"
  value       = aws_kms_key.shared_key.key_id
}

output "shared_key_arn" {
  description = "The ARN of the shared KMS key"
  value       = aws_kms_key.shared_key.arn
}

output "shared_key_alias" {
  description = "The alias of the shared KMS key"
  value       = aws_kms_alias.shared_key.name
}

output "cloudtrail_key_id" {
  description = "The ID of the CloudTrail KMS key"
  value       = var.create_cloudtrail_key ? aws_kms_key.cloudtrail_key[0].key_id : null
}

output "cloudtrail_key_arn" {
  description = "The ARN of the CloudTrail KMS key"
  value       = var.create_cloudtrail_key ? aws_kms_key.cloudtrail_key[0].arn : null
}

output "cloudtrail_key_alias" {
  description = "The alias of the CloudTrail KMS key"
  value       = var.create_cloudtrail_key ? aws_kms_alias.cloudtrail_key[0].name : null
} 