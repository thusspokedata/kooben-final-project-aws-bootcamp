# Add data sources at the top
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

# AWS managed policies for S3 access
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = var.role_id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_read_access" {
  role       = var.role_id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Custom inline policy for other permissions
resource "aws_iam_role_policy" "ec2_s3_secrets_policy" {
  name = "ec2-s3-secrets-policy-${var.sufix}"
  role = var.role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [
          "arn:aws:kms:${local.region}:${local.account_id}:key/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ]
        Resource = [
          "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:app-env-${var.s3_bucket_name}-*",
          "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:frontend-env-${var.s3_bucket_name}-*"
        ]
      }
    ]
  })
} 