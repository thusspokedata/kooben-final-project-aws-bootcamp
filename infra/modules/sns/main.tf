resource "aws_sns_topic" "asg_notifications" {
  name = "asg-notifications-${var.sufix}"
  
  # Enable server-side encryption for SNS topic
  # Added as per tfsec recommendation: aws-sns-enable-topic-encryption
  # This prevents SNS messages from being read if the service is compromised
  #tfsec:ignore:aws-sns-topic-encryption-use-cmk
  kms_master_key_id = "alias/aws/sns"
  
  tags = merge(
    var.tags,
    {
      Name = "asg-notifications-${var.sufix}"
    }
  )
}

resource "aws_sns_topic_subscription" "asg_notifications_email" {
  topic_arn = aws_sns_topic.asg_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Optional: Add policy to allow Auto Scaling to publish to this topic
resource "aws_sns_topic_policy" "asg_notifications" {
  arn    = aws_sns_topic.asg_notifications.arn
  policy = data.aws_iam_policy_document.asg_notification_policy.json
}

data "aws_iam_policy_document" "asg_notification_policy" {
  statement {
    sid    = "AllowASGNotifications"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }
    actions = [
      "SNS:Publish"
    ]
    resources = [
      aws_sns_topic.asg_notifications.arn
    ]
  }
} 