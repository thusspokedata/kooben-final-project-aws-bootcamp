resource "aws_vpc" "kooben_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "kooben-vpc-${var.sufix}"
  })
}

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