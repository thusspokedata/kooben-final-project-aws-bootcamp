variable "kooben_cidr" {
  description = "value of the CIDR block for the Frankfurt VPC"
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "tags" {
  description = "a map of tags"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR block for the ingress rule"
  type        = string
}

variable "ingress_ports_list" {
  description = "a list of ingress ports"
  type        = list(number)
}
