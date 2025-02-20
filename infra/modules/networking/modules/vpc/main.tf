# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_vpc" "kooben_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "kooben-vpc-${var.sufix}"
  })
}

# KMS key for CloudWatch Logs encryption
resource "aws_kms_key" "cloudwatch_log_key" {
  description             = "KMS key for CloudWatch Logs encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "/aws/vpc/flow-logs-${var.sufix}"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.cloudwatch_log_key.arn
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc-flow-log-role-${var.sufix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Role Policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "vpc-flow-log-policy-${var.sufix}"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = aws_cloudwatch_log_group.flow_log.arn
      }
    ]
  })
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc_flow_log" {
  vpc_id          = aws_vpc.kooben_vpc.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn

  tags = merge(var.tags, {
    Name = "vpc-flow-log-${var.sufix}"
  })
}

# Subnets
resource "aws_subnet" "kooben_public_subnet" {
  vpc_id     = aws_vpc.kooben_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = merge(var.tags, {
    Name = "kooben-public-subnet-${var.sufix}"
  })
}

resource "aws_subnet" "kooben_private_subnet" {
  vpc_id     = aws_vpc.kooben_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = merge(var.tags, {
    Name = "kooben-private-subnet-${var.sufix}"
  })
} 