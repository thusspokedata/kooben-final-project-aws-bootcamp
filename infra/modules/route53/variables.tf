variable "sufix" {
  type        = string
  description = "Sufix to be used in resource names"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
}

variable "frontend_alb_dns_name" {
  type        = string
  description = "DNS name of the frontend ALB"
}

variable "frontend_alb_zone_id" {
  type        = string
  description = "Zone ID of the frontend ALB"
}

variable "backend_alb_dns_name" {
  type        = string
  description = "DNS name of the backend ALB"
}

variable "backend_alb_zone_id" {
  type        = string
  description = "Zone ID of the backend ALB"
} 