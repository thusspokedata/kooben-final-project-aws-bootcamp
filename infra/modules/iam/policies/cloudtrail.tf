# CloudTrail CloudWatch policy definitions

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Generate the log stream name that CloudTrail will use
locals {
  cloudtrail_log_stream = "${data.aws_caller_identity.current.account_id}_CloudTrail_${data.aws_region.current.name}"
}

# Policy for CloudTrail to write to CloudWatch Logs
resource "aws_iam_role_policy" "cloudtrail_cloudwatch_policy" {
  name = "cloudtrail-cloudwatch-policy-${var.sufix}"
  role = var.cloudtrail_role_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "logs:CreateLogStream",
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/cloudtrail/kooben-${var.sufix}:log-stream:${local.cloudtrail_log_stream}"
      },
      {
        Effect = "Allow",
        Action = "logs:PutLogEvents",
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/cloudtrail/kooben-${var.sufix}:log-stream:${local.cloudtrail_log_stream}"
      }
    ]
  })
} 