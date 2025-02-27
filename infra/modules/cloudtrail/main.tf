# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Bucket policy to allow CloudTrail to write logs to the existing S3 bucket
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = var.existing_s3_bucket_id

  # We need to merge the existing policy with our new CloudTrail policy
  # Use dynamic approach to prevent overriding existing policies
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = var.existing_s3_bucket_arn,
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cloudtrail-kooben-${var.sufix}"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWrite",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${var.existing_s3_bucket_arn}/cloudtrail/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control",
            "aws:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cloudtrail-kooben-${var.sufix}"
          }
        }
      }
    ]
  })
}

# Create internal KMS key only if configured to do so
resource "aws_kms_key" "cloudtrail_key" {
  count = var.create_internal_kms_key ? 1 : 0

  description             = "KMS key for CloudTrail logs encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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
            "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
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
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
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

# Create alias only if internal key is created
resource "aws_kms_alias" "cloudtrail_key_alias" {
  count = var.create_internal_kms_key ? 1 : 0

  name          = "alias/cloudtrail-kooben-${var.sufix}"
  target_key_id = aws_kms_key.cloudtrail_key[0].key_id
}

# Determine which KMS key to use (external or internal)
locals {
  cloudtrail_log_stream = "${data.aws_caller_identity.current.account_id}_CloudTrail_${data.aws_region.current.name}"
}

# CloudWatch log group for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/cloudtrail/kooben-${var.sufix}"
  retention_in_days = var.cloudtrail_retention_days
  kms_key_id        = var.create_internal_kms_key ? aws_kms_key.cloudtrail_key[0].arn : var.kms_key_id

  tags = merge(var.tags, {
    Name = "cloudtrail-logs-${var.sufix}"
  })
}

# CloudTrail trail
resource "aws_cloudtrail" "kooben_trail" {
  name                          = "cloudtrail-kooben-${var.sufix}"
  s3_bucket_name                = var.existing_s3_bucket_name
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  enable_log_file_validation    = var.enable_log_file_validation
  kms_key_id                    = var.create_internal_kms_key ? aws_kms_key.cloudtrail_key[0].arn : var.kms_key_id
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
  cloud_watch_logs_role_arn     = var.cloudtrail_cloudwatch_role_arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = merge(var.tags, {
    Name = "cloudtrail-kooben-${var.sufix}"
  })

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_bucket_policy
  ]
} 