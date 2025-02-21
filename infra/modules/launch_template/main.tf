resource "aws_launch_template" "backend_template" {
  name = "backend-template-${var.sufix}"

  image_id      = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type

  # Establish the latest version of the launch template
  update_default_version = true

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.backend_security_group_id]
  }

  # Add metadata options to enforce IMDSv2 (tfsec recommendation)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Enforce IMDSv2
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    s3_bucket_name         = var.s3_bucket_name
    docker_compose_version = var.docker_compose_version
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend-instance-${var.sufix}"
    }
  }

  tags = {
    Name = "backend-template-${var.sufix}"
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }
} 