resource "aws_launch_template" "backend_template" {
  name = "backend-template-${var.sufix}"

  image_id      = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [var.backend_security_group_id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    s3_bucket_name = var.s3_bucket_name
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
} 