output "topic_arn" {
  description = "The ARN of the SNS topic for ASG notifications"
  value       = aws_sns_topic.asg_notifications.arn
} 