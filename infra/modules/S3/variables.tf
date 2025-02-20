variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment_variables" {
  description = "Map of environment variables to store in Secrets Manager"
  type        = map(string)
  sensitive   = true
}