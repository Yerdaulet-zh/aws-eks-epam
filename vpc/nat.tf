resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "${local.project_name}-nat-eip" }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.managed["public_a"].id

  tags = { Name = "${local.project_name}-nat-gw" }

  depends_on = [aws_internet_gateway.igw]
}
