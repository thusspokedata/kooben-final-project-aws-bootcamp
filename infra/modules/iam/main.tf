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

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-${var.sufix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_read_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
} 