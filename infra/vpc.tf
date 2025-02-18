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