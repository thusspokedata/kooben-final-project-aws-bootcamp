variable "sufix" {
  description = "Suffix for the IAM policy names"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for which to create policies"
  type        = string
}

variable "role_id" {
  description = "ID of the IAM role to attach policies to"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cloudtrail_role_id" {
  description = "ID of the CloudTrail IAM role to attach policies to"
  type        = string
}