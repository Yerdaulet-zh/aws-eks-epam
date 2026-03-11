resource "aws_subnet" "managed" {
  for_each = local.subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = "${local.region}${each.value.az}"

  map_public_ip_on_launch = each.value.public

  tags = {
    Name    = "${local.project_name}-${each.key}"
    Project = local.project_name

    # EKS specific tags for Load Balancer Auto-Discovery
    "kubernetes.io/role/${each.value.usage}" = "1"
    "kubernetes.io/cluster/my-eks-cluster"   = "shared"
  }
}
