variable "sufix" {
  type = string
}

variable "ec2_specs" {
  description = "EC2 instance specifications"
  type = object({
    instance_type = string
    ami           = string
  })
}

variable "frontend_security_group_id" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "docker_compose_version" {
  type    = string
  default = "2.20.2"
}
