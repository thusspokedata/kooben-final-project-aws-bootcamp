variable "sufix" {
  description = "Suffix to append to resources names"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID of the security group for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "domain_name" {
  description = "The domain name used for the Route53 records"
  type        = string
}

variable "create_acm_certificate" {
  description = "Whether to create an ACM certificate"
  type        = bool
  default     = true
}

variable "validate_certificate" {
  description = "Whether to validate the certificate with Route53 (requires an existing hosted zone)"
  type        = bool
  default     = false
} 