variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for first public subnet"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for second public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for first private subnet"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for second private subnet"
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

variable "random_suffix" {
  description = "Random suffix for resource naming"
  type        = string
}