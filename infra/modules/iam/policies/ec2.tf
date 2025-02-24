# Add data sources at the top
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_role_policy" "ec2_s3_secrets_policy" {
  name = "ec2-s3-secrets-policy-${var.sufix}"
  role = var.role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListObjects",
          "s3:ListObjectsV2",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:kms:${local.region}:${local.account_id}:key/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ]
        Resource = "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:app-env-${var.s3_bucket_name}-*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:ListAttachedRolePolicies",
          "iam:GetRole",
          "iam:GetRolePolicy"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:role/ec2-role-${var.sufix}"
        ]
      }
    ]
  })
} 