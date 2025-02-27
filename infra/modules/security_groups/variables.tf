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

variable "ingress_ports_list_alb" {
  description = "List of ports for ALB ingress"
  type        = list(number)
  default     = [80, 443]
}

variable "egress_ports_map_alb" {
  description = "Map of egress ports to security groups for ALB"
  type        = map(string)
  default = {
    "3000" = "backend"
    "4000" = "frontend"
  }
}

variable "sg_ingress_cidr" {
  description = "CIDR block for security group ingress rules"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}
