variable "kooben_cidr" {
  description = "value of the CIDR block for the Frankfurt VPC"
  type = string
}

variable "kooben_subnets" {
  description = "a subnets list"
  type        = list(string)
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

# variable "access_key" {
#     type = string
# }

# variable "secret_key" {
#     type = string
# }