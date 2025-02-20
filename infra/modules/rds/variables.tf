variable "sufix" {
  description = "Suffix for resource naming"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "database_user" {
  description = "Database master user"
  type        = string
}

variable "database_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "database_security_group_id" {
  description = "ID of the security group for the database"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
} 