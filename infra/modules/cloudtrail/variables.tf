variable "sufix" {
  description = "Sufix to add to all resources"
  type        = string
}

variable "enable_log_file_validation" {
  description = "Whether to enable log file validation for CloudTrail"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Whether to include global service events in CloudTrail"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Whether to enable CloudTrail in all regions"
  type        = bool
  default     = true
}

variable "cloudtrail_retention_days" {
  description = "Number of days to retain CloudTrail logs in CloudWatch"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "existing_s3_bucket_name" {
  description = "Name of existing S3 bucket to store CloudTrail logs"
  type        = string
}

variable "existing_s3_bucket_id" {
  description = "ID of existing S3 bucket to store CloudTrail logs"
  type        = string
}

variable "existing_s3_bucket_arn" {
  description = "ARN of existing S3 bucket to store CloudTrail logs"
  type        = string
}

variable "cloudtrail_cloudwatch_role_arn" {
  description = "ARN of the IAM role for CloudTrail to send logs to CloudWatch"
  type        = string
}

variable "cloudtrail_cloudwatch_role_id" {
  description = "ID of the IAM role for CloudTrail to send logs to CloudWatch"
  type        = string
}

variable "kms_key_id" {
  description = "ARN of the KMS key used for encrypting CloudTrail logs"
  type        = string
  default     = ""
}

variable "create_internal_kms_key" {
  description = "Whether to create an internal KMS key for CloudTrail"
  type        = bool
  default     = true
} 