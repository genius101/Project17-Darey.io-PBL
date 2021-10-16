
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "Public_Subnet" {
  subnet_id      = element(aws_subnet.public.*.id, 0)
  route_table_id = aws_route_table.route_table.id
}
