variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "sufix" {
  description = "Suffix for resource naming"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
} 