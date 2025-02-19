variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "sufix" {
  description = "Suffix for naming convention"
  type        = string
}

variable "ingress_ports_list_backend" {
  description = "List of ports for backend security group"
  type        = list(number)
}

variable "ingress_ports_list_frontend" {
  description = "List of ports for frontend security group"
  type        = list(number)
}

variable "sg_ingress_cidr" {
  description = "CIDR block for security group ingress rules"
  type        = string
}
