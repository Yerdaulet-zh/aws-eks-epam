resource "aws_subnet" "managed" {
  for_each = var.subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}${each.value.az}"

  map_public_ip_on_launch = each.value.public

  tags = {
    Name    = "${var.project_name}-${each.key}"
    Project = var.project_name

    # EKS specific tags for Load Balancer Auto-Discovery
    "kubernetes.io/role/${each.value.usage}" = "1"
    "kubernetes.io/cluster/my-eks-cluster"   = "shared"
  }
}
