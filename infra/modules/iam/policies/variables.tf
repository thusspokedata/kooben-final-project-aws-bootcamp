variable "sufix" {
  description = "Suffix for resource naming"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "role_id" {
  description = "ID of the IAM role"
  type        = string
}

variable "tags" {
  description = "Tags to be added to resources"
  type        = map(string)
}