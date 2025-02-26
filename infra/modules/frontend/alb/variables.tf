variable "sufix" {
  type        = string
  description = "Sufix to be used in resource names"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "alb_security_group_id" {
  type        = string
  description = "ID of the security group for the ALB"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}
