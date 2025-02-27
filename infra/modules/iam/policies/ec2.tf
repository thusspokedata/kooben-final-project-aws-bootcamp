# Add data sources at the top
# data "aws_caller_identity" "current" {}
# data "aws_region" "current" {}

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

# IAM policy for EC2 instances to access S3
resource "aws_iam_role_policy" "cloudfront_s3_policy" {
  name   = "cloudfront_s3_policy-${var.sufix}"
  role   = var.role_id
  policy = data.aws_iam_policy_document.cloudfront_s3.json
}

data "aws_iam_policy_document" "cloudfront_s3" {
  statement {
    sid = "AllowS3Actions"

    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }
} 