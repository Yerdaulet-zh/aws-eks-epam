module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  create_vpc = true

  name = "eks-vpc-epam"
  cidr = "10.0.0.0/16"

  # SUBNETS
  azs                 = ["eu-central-1a", "eu-central-1b"]
  database_subnets    = ["10.0.21.0/24", "10.0.22.0/24"]
  elasticache_subnets = ["10.0.31.0/24", "10.0.32.0/24"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  # redshift_subnets    = ["10.0.41.0/24", "10.0.42.0/24"]
  intra_subnets = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]

  # GATEWAY
  create_igw = true

  # disable nat gateway
  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # DNS
  enable_dns_support   = true
  enable_dns_hostnames = true

  # ACL
  manage_default_network_acl = true

  # CACHE
  create_elasticache_subnet_group       = true
  create_elasticache_subnet_route_table = true


  # RDS
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true  # enable internal vpc communication
  create_database_internet_gateway_route = false # disable vpc internet access to rds subnets
  create_database_nat_gateway_route      = false

  # REDSHIFT
  enable_public_redshift = false

  # TAGS

  # REQUIRED for EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/eks-cluster" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/eks-cluster" = "shared"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
