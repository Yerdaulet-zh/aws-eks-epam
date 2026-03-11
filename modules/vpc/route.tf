resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "${var.project_name}-public-rt"
    Project = var.project_name
  }

}

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main.id
#   }

#   tags = {
#     Name    = "${var.project_name}-private-rt"
#     Project = var.project_name
#   }
# }

resource "aws_route_table_association" "public" {
  for_each = {
    for key, value in var.subnets : key => value
    if value.public == true
  }

  subnet_id      = aws_subnet.managed[each.key].id
  route_table_id = aws_route_table.public.id
}


# resource "aws_route_table_association" "private" {
#   for_each = {
#     for key, value in var.subnets : key => value
#     if value.public == false
#   }

#   subnet_id      = aws_subnet.managed[each.key].id
#   route_table_id = aws_route_table.private.id
# }
