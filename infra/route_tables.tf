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