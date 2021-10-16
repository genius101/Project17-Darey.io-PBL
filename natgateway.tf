resource "aws_eip" "nat_eip" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  # tags = merge(
  #   var.additional_tags,
  #   {
  #     Name = format("EIP-%s",aws_eip.nat_eip[count.index].id)
  #   } 
  # )
}

  resource "aws_nat_gateway" "nat" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
  #tags = merge(
  #   var.additional_tags,
  #   {
  #     Name   =  format("Nat-%s",aws_nat_gateway.nat[count.index].id)
  #   } 
  # )
}

resource "aws_route_table" "route_private" {
  vpc_id = "aws_vpc.main.id"

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "aws_nat_gateway.nat[count.index].id"
  }

  tags = {
    Name = "private-route-table-demo"
  }
}

resource "aws_route_table_association" "Private" {
  subnet_id      = element(aws_subnet.public.*.id, 0)
  route_table_id = aws_route_table.route_private.id
}
