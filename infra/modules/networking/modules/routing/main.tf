# Only keep Internet Gateway and public route table
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

# Route table association for first public subnet
resource "aws_route_table_association" "kooben_public_rt_assoc" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.kooben_public_rt.id
}

# Route table association for second public subnet
resource "aws_route_table_association" "kooben_public_rt_assoc_2" {
  subnet_id      = var.public_subnet_2_id
  route_table_id = aws_route_table.kooben_public_rt.id
} 