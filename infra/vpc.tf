resource "aws_vpc" "kooben_vpc" {
  cidr_block = var.kooben_cidr
  tags = {
    Name = "kooben_vpc-${local.sufix}"
  }
}

resource "aws_subnet" "kooben_public_subnet" {
  vpc_id                  = aws_vpc.kooben_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = false # ⚠️ Set to FALSE to prevent automatic public IP assignment (tfsec recommendation)
  tags = {
    Name = "kooben_public_subnet-${local.sufix}"
  }
}

resource "aws_subnet" "kooben_private_subnet" {
  vpc_id     = aws_vpc.kooben_vpc.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "kooben_private_subnet-${local.sufix}"
  }
}

# IAM Role to allow VPC Flow Logs to write logs to S3
resource "aws_iam_role" "flow_logs_role" {
  name = "kooben-vpc-flow-logs-role"

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

# IAM Policy to grant necessary permissions for Flow Logs
resource "aws_iam_policy" "flow_logs_policy" {
  name = "kooben-vpc-flow-logs-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${module.myBucket.bucket_arn}/vpc-flow-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*" # Restricting to specific AWSLogs path (tfsec recommendation)
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ]
        Resource = [
          "${module.myBucket.bucket_arn}"
        ]
      }
    ]
  })
}

# Attach the IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "flow_logs_policy_attach" {
  role       = aws_iam_role.flow_logs_role.name
  policy_arn = aws_iam_policy.flow_logs_policy.arn
}

# VPC Flow Logs with IAM Role for logging to S3
resource "aws_flow_log" "kooben_vpc_logs" {
  log_destination      = "${module.myBucket.bucket_arn}/vpc-flow-logs/"
  log_destination_type = "s3"
  traffic_type        = "ALL"
  vpc_id              = aws_vpc.kooben_vpc.id
  iam_role_arn        = aws_iam_role.flow_logs_role.arn
}

data "aws_caller_identity" "current" {}