variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the first public subnet"
  type        = string
}

variable "public_subnet_2_id" {
  description = "ID of the second public subnet"
  type        = string
}

variable "private_subnet_1_id" {
  description = "ID of the first private subnet"
  type        = string
}

variable "private_subnet_2_id" {
  description = "ID of the second private subnet"
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