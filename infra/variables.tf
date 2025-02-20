variable "kooben_cidr" {
  description = "value of the CIDR block for the Frankfurt VPC"
  type        = string
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

variable "ingress_ports_list_backend" {
  description = "a list of ingress ports"
  type        = list(number)
}

variable "ingress_ports_list_frontend" {
  description = "a list of ingress ports"
  type        = list(number)
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "ec2_specs" {
  description = "EC2 instance specifications"
  type = object({
    instance_type = string
    ami           = string
  })
}

variable "db_password" {
  description = "Master password for RDS instance"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Master username for RDS instance"
  type        = string
}