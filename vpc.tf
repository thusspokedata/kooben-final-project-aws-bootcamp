resource "aws_vpc" "kooben_vpc" {
  cidr_block = var.kooben_cidr
  tags = {
    Name = "kooben_vpc-${local.sufix}"
  }
}

resource "aws_subnet" "kooben_public_subnet" {
  vpc_id                  = aws_vpc.kooben_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "kooben_public_subnet-${local.sufix}"
  }
}

resource "aws_subnet" "kooben_private_subnet" {
  vpc_id     = aws_vpc.kooben_vpc.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "kooben_private_subnet-${local.sufix}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.kooben_vpc.id
  tags = {
    Name = "igw_kooben-${local.sufix}"
  }
}

resource "aws_route_table" "kooben_public_rt" {
  vpc_id = aws_vpc.kooben_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "kooben_public_rt-${local.sufix}"
  }
}

resource "aws_route_table_association" "kooben_public_rt_assoc" {
  subnet_id      = aws_subnet.kooben_public_subnet.id
  route_table_id = aws_route_table.kooben_public_rt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "public_instance_sg"
  description = "Allow SSH, HTTPS, and HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.kooben_vpc.id

  tags = {
    Name = "Public instance security group-${local.sufix}"
  }

  dynamic "ingress" {
    for_each = var.ingress_ports_list
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
  ip_protocol       = "-1" # Allow all protocols
}

module "myBucket" {
  source      = "./modules/s3"
  bucket_name = local.s3_sufix
}