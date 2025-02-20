# VPC
resource "aws_vpc" "kooben_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "kooben-vpc-${var.sufix}"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "kooben_igw" {
  vpc_id = aws_vpc.kooben_vpc.id

  tags = merge(var.tags, {
    Name = "kooben-igw-${var.sufix}"
  })
}

# Subnets
resource "aws_subnet" "kooben_public_subnet" {
  vpc_id     = aws_vpc.kooben_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = merge(var.tags, {
    Name = "kooben-public-subnet-${var.sufix}"
  })
}

resource "aws_subnet" "kooben_private_subnet" {
  vpc_id     = aws_vpc.kooben_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = merge(var.tags, {
    Name = "kooben-private-subnet-${var.sufix}"
  })
}

# Route Tables
resource "aws_route_table" "kooben_public_rt" {
  vpc_id = aws_vpc.kooben_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kooben_igw.id
  }

  tags = merge(var.tags, {
    Name = "kooben-public-rt-${var.sufix}"
  })
}

resource "aws_route_table_association" "kooben_public_rt_assoc" {
  subnet_id      = aws_subnet.kooben_public_subnet.id
  route_table_id = aws_route_table.kooben_public_rt.id
} 