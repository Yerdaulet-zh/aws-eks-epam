resource "aws_vpc" "vpc" {
  cidr_block                           = var.vpc_cidr
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true
  tags = {
    Project = "${var.project_name}"
  }
}
