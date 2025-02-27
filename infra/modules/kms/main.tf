# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = coalesce(var.cloudtrail_account_id, data.aws_caller_identity.current.account_id)
  region     = coalesce(var.cloudtrail_region, data.aws_region.current.name)
}

# Shared KMS key for general purpose
resource "aws_kms_key" "shared_key" {
  description             = "Shared KMS key for general encryption needs"
  deletion_window_in_days = var.shared_key_deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation

  tags = merge(var.tags, {
    Name = "shared-kms-key-${var.sufix}"
  })
}

resource "aws_kms_alias" "shared_key" {
  name          = "alias/kooben-shared-key-${var.sufix}"
  target_key_id = aws_kms_key.shared_key.key_id
}

# CloudTrail-specific KMS key
resource "aws_kms_key" "cloudtrail_key" {
  count = var.create_cloudtrail_key ? 1 : 0

  description             = "KMS key for CloudTrail logs encryption"
  deletion_window_in_days = var.cloudtrail_key_deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Allow CloudTrail to encrypt logs",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = [
          "kms:GenerateDataKey*"
        ],
        Resource = "*",
        Condition = {
          StringLike = {
            "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
          }
        }
      },
      {
        Sid    = "Allow CloudTrail to describe key",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = [
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs to use the key",
        Effect = "Allow",
        Principal = {
          Service = "logs.${local.region}.amazonaws.com"
        },
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "cloudtrail-kms-key-${var.sufix}"
  })
}

resource "aws_kms_alias" "cloudtrail_key" {
  count = var.create_cloudtrail_key ? 1 : 0

  name          = "alias/cloudtrail-kooben-${var.sufix}"
  target_key_id = aws_kms_key.cloudtrail_key[0].key_id
} 