variable "sufix" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "launch_template_id" {
  type = string
} 