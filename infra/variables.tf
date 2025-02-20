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

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "jwt_secret_backend" {
  description = "Secret key for JWT"
  type        = string
  sensitive   = true
}

variable "cloudinary_api_key" {
  description = "Cloudinary API Key"
  type        = string
  sensitive   = true
}

variable "cloudinary_api_secret" {
  description = "Cloudinary API Secret"
  type        = string
  sensitive   = true
}

variable "cloudinary_url" {
  description = "Cloudinary URL"
  type        = string
  sensitive   = true
}

variable "clerk_secret_key" {
  description = "Clerk Secret Key"
  type        = string
  sensitive   = true
}

###########################################
# Start/Stop Schedules for EC2, RDS, ASG #
##########################################
variable "ec2_start_stop_schedules" {
  description = "Schedules and tags to turn off and turn on ec2 instances"
  type        = map(map(string))
  default     = {}
}


variable "rds_start_stop_schedules" {
  description = "Schedules and tags to turn off and turn on RDS instances"
  type        = map(map(string))
  default     = {}
}

variable "asg_start_stop_schedules" {
  description = "Schedules and tags to turn off and turn on EC2 instances using an ASG"
  type        = map(map(string))
  default     = {}
}

variable "timezone" {
  description = "Timezone for Schedules"
  type        = string
}