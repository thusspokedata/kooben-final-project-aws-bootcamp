variable "sufix" {
  type        = string
  description = "Sufix to be used in resource names"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the target group for the load balancer"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "launch_template_id" {
  type        = string
  description = "ID of the launch template"
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic for ASG notifications"
  type        = string
  default     = ""
}
