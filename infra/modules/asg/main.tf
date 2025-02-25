resource "aws_autoscaling_group" "backend_asg" {
  name                = "backend-asg-${var.sufix}"
  desired_capacity    = 0
  max_size           = 3
  min_size           = 0
  target_group_arns  = [var.target_group_arn]
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
} 