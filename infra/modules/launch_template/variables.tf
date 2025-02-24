variable "ec2_specs" {
  description = "EC2 instance specifications"
  type = object({
    instance_type = string
    ami           = string
  })
}

variable "backend_security_group_id" {
  description = "ID of the backend security group"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for application files"
  type        = string
}

variable "sufix" {
  description = "Suffix for resource naming"
  type        = string
}

variable "docker_compose_version" {
  description = "Version of Docker Compose to install"
  type        = string
  default     = "2.20.2" # Default version if not specified
}

variable "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet for the EC2 instance"
  type        = string
}