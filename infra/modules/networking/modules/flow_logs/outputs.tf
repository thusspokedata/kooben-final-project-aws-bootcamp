output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.flow_log.arn
} 