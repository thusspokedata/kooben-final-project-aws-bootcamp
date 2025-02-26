variable "sufix" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "launch_template_id" {
  type = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic for ASG notifications"
  type        = string
} 