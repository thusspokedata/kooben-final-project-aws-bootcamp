variable "sufix" {
  description = "Sufix to add to all resources"
  type        = string
}

variable "tags" {
  description = "Tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create_cloudtrail_key" {
  description = "Whether to create a KMS key for CloudTrail"
  type        = bool
  default     = true
}

variable "cloudtrail_key_deletion_window_in_days" {
  description = "Duration in days after which the CloudTrail KMS key is deleted"
  type        = number
  default     = 7
}

variable "shared_key_deletion_window_in_days" {
  description = "Duration in days after which the shared KMS key is deleted"
  type        = number
  default     = 7
}

variable "enable_key_rotation" {
  description = "Whether to enable key rotation for KMS keys"
  type        = bool
  default     = true
}

# CloudTrail specific variables
variable "cloudtrail_account_id" {
  description = "AWS account ID for CloudTrail"
  type        = string
  default     = ""
}

variable "cloudtrail_region" {
  description = "AWS region for CloudTrail"
  type        = string
  default     = ""
} 