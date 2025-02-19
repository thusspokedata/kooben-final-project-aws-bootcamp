resource "aws_security_group" "sg_public_instance" {
  name        = "public_instance_sg"
  description = "Security Group for Frontend: Allows HTTP (80), HTTPS (443), SSH (22), and Port 4000."
  vpc_id      = aws_vpc.kooben_vpc.id

  tags = {
    Name = "sg_frontend-${local.sufix}"
  }

  dynamic "ingress" {
    for_each = toset(var.ingress_ports_list_frontend)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_public_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
