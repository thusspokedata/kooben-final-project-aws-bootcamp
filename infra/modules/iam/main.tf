# Main IAM configuration
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# locals {
#   account_id = data.aws_caller_identity.current.account_id
#   region     = data.aws_region.current.name
# } 

module "roles" {
  source         = "./roles"
  sufix          = var.sufix
  tags           = var.tags
  s3_bucket_name = var.s3_bucket_name
}

module "policies" {
  source         = "./policies"
  sufix          = var.sufix
  s3_bucket_name = var.s3_bucket_name
  role_id        = module.roles.ec2_role_id
  tags           = var.tags
} 