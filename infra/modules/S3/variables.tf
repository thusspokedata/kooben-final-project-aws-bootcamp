variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment_variables" {
  description = "Map of environment variables to store in Secrets Manager"
  type        = map(string)
  sensitive   = true
}

variable "frontend_environment_variables" {
  description = "Environment variables for frontend application"
  type = object({
    NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY = string
    CLERK_SECRET_KEY                  = string
    NEXT_PUBLIC_CLERK_SIGN_IN_URL     = string
    NEXT_PUBLIC_CLERK_SIGN_UP_URL     = string
    NODE_ENV                          = string
    NEXT_PUBLIC_API_URL               = string
    PORT                              = string
  })
  sensitive = true
}