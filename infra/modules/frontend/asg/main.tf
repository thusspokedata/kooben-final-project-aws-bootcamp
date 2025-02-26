resource "aws_autoscaling_group" "frontend" {
  name                = "frontend-asg-${var.sufix}"
  desired_capacity    = 1
  max_size           = 2
  min_size           = 1
  target_group_arns  = [var.target_group_arn]
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "frontend-instance-${var.sufix}"
    propagate_at_launch = true
  }
}
