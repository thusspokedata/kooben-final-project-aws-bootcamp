resource "aws_security_group" "sg_backend" {
  name        = "ec2-rds-${var.sufix}"
  description = "Security Group for EC2 instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.ingress_ports_list_backend)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }

  tags = {
    Name = "ec2-rds-${var.sufix}"
  }
}

resource "aws_security_group" "sg_frontend" {
  name        = "sg_kooben-frontend"
  description = "Security Group for Frontend"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg_frontend-${var.sufix}"
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

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_backend" {
  security_group_id = aws_security_group.sg_backend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_frontend" {
  security_group_id = aws_security_group.sg_frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Database Security Group
resource "aws_security_group" "sg_database" {
  name        = "rds-ec2-${var.sufix}"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  # Permitir tráfico desde las instancias EC2
  ingress {
    description     = "Allow PostgreSQL from EC2 instances"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_backend.id]
  }

  tags = {
    Name = "rds-ec2-${var.sufix}"
  }
}

# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "alb-${var.sufix}"
  description = "Security Group for ALB"
  vpc_id      = var.vpc_id

  # Dynamic ingress rules
  dynamic "ingress" {
    for_each = toset(var.ingress_ports_list_alb)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow traffic on port ${ingress.value}"
    }
  }

  # Dynamic egress rules
  dynamic "egress" {
    for_each = var.egress_ports_map_alb
    content {
      from_port       = egress.key
      to_port         = egress.key
      protocol        = "tcp"
      security_groups = [egress.value == "backend" ? aws_security_group.sg_backend.id : aws_security_group.sg_frontend.id]
      description     = "Allow traffic to ${egress.value} instances on port ${egress.key}"
    }
  }

  tags = {
    Name = "alb-${var.sufix}"
  }
}
