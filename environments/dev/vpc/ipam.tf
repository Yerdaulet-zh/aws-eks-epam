resource "aws_vpc_ipam" "main" {
  operating_regions {
    region_name = "eu-central-1"
  }
}

resource "aws_vpc_ipam_pool" "ipv6" {
  address_family = "ipv6"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  locale         = "eu-central-1"

  description = "Regional IPv6 pool for EKS development"
}

resource "aws_vpc_ipam_pool_cidr" "ipv6_provision" {
  ipam_pool_id   = aws_vpc_ipam_pool.ipv6.id
  netmask_length = 52
}
