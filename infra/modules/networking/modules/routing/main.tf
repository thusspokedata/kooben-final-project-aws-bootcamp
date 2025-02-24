resource "aws_internet_gateway" "kooben_igw" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "kooben-igw-${var.sufix}"
  })
}

resource "aws_route_table" "kooben_public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kooben_igw.id
  }

  tags = merge(var.tags, {
    Name = "kooben-public-rt-${var.sufix}"
  })
}

resource "aws_route_table_association" "kooben_public_rt_assoc" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.kooben_public_rt.id
}

# NAT Gateway for private subnets internet access
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "kooben-nat-eip-${var.sufix}"
  })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id  # NAT Gateway must be in a public subnet

  tags = merge(var.tags, {
    Name = "kooben-nat-${var.sufix}"
  })
}

# Route table for private subnets - routes traffic through NAT Gateway
resource "aws_route_table" "kooben_private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "kooben-private-rt-${var.sufix}"
  })
}

# Associate each private subnet with the private route table
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = var.private_subnet_1_id
  route_table_id = aws_route_table.kooben_private_rt.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = var.private_subnet_2_id
  route_table_id = aws_route_table.kooben_private_rt.id
} 