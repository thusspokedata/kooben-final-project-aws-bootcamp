variable "kooben_cidr" {
  description = "value of the CIDR block for the Frankfurt VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
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
  description = "List of ports for backend security group"
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


variable "CLERK_SECRET_KEY" {
  description = "Clerk Secret Key"
  type        = string
  sensitive   = true
}

variable "NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY" {
  description = "Clerk Publishable Key"
  type        = string
  sensitive   = true
}

variable "NEXT_PUBLIC_KOOBEN_API_URL" {
  description = "Frontend API URL for Kooben"
  type        = string
  default     = ""
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

variable "frontend_environment_variables" {
  description = "Environment variables for frontend application"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
}

variable "certificate_arn" {
  description = "ARN of an existing ACM certificate to use with the ALB"
  type        = string
  default     = ""
}

variable "notification_email" {
  description = "Email address to receive ASG notifications"
  type        = string
  default     = ""
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