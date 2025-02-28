resource "aws_autoscaling_group" "backend_asg" {
  name                = "backend-asg-${var.sufix}"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  target_group_arns   = [var.target_group_arn]
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "backend-instance-${var.sufix}"
    propagate_at_launch = true
  }
  
  # Add tag for ASG itself to be used by the scheduler
  tag {
    key                 = "Name"
    value               = "backend-asg-${var.sufix}"
    propagate_at_launch = false
  }
}

# Add notifications for ASG events
resource "aws_autoscaling_notification" "backend_asg_notifications" {
  group_names = [aws_autoscaling_group.backend_asg.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = var.sns_topic_arn
} 