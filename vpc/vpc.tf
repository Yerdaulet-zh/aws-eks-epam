resource "aws_vpc" "vpc" {
  cidr_block                           = local.vpc_cidr_block
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true
  tags = {
    Project = "${local.project_name}"
  }
}
