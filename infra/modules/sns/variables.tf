variable "sufix" {
  description = "Suffix to be used on all resource names"
  type        = string
}

variable "notification_email" {
  description = "Email address to receive ASG notifications"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 