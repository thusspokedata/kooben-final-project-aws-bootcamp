resource "aws_launch_template" "frontend_template" {
  name = "frontend-template-${var.sufix}"

  image_id      = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type

  update_default_version = true

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.frontend_security_group_id]
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
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
      Name = "frontend-instance-${var.sufix}"
    }
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }

  key_name = "kooben-key-pair"
}
