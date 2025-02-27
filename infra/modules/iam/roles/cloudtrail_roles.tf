# CloudTrail IAM Role for CloudWatch integration
resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  name = "cloudtrail-cloudwatch-role-${var.sufix}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "cloudtrail-cloudwatch-role-${var.sufix}"
    }
  )
} 