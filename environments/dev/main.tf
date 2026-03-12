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
  intra_subnets           = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]
  map_public_ip_on_launch = true

  # GATEWAY
  create_igw             = true
  create_egress_only_igw = true # IPv6 does not use NAT, gloabally unique IP addresses

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
  create_database_subnet_route_table     = false # internal vpc communication is enabled
  create_database_internet_gateway_route = false # disable vpc internet access to rds subnets
  create_database_nat_gateway_route      = false

  # REDSHIFT
  enable_public_redshift = false

  # VPC LOGS
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = true
  # IAM
  create_flow_log_cloudwatch_iam_role     = true
  vpc_flow_log_iam_policy_name            = "vpc-flow-log-to-cloudwatch"
  vpc_flow_log_iam_policy_use_name_prefix = true # appends a random string at the end of policy name
  vpc_flow_log_iam_role_name              = "vpc-flow-log-role"
  vpc_flow_log_iam_role_use_name_prefix   = true
  vpc_flow_log_iam_role_path              = "/engineering/devops/"
  vpc_flow_log_permissions_boundary       = null
  # Storage & Cost Optimization
  flow_log_cloudwatch_log_group_class             = "INFREQUENT_ACCESS"
  flow_log_cloudwatch_log_group_retention_in_days = 30
  flow_log_max_aggregation_interval               = 600 # 10min
  # Data Structure (For Athena/S3)
  flow_log_destination_type           = "cloud-watch-logs"
  flow_log_destination_arn            = ""
  flow_log_file_format                = "parquet"
  flow_log_hive_compatible_partitions = true
  flow_log_per_hour_partition         = true
  # Security & Encryption
  flow_log_cloudwatch_log_group_kms_key_id = null
  flow_log_cloudwatch_iam_role_arn         = ""
  flow_log_deliver_cross_account_role      = null
  flow_log_cloudwatch_iam_role_conditions  = []
  # Traffic Filtering
  flow_log_traffic_type = "REJECT"
  # Cloudwatch log group
  flow_log_cloudwatch_log_group_skip_destroy = true
  flow_log_cloudwatch_log_group_name_prefix  = "/aws/vpc-flow-log/"
  flow_log_cloudwatch_log_group_name_suffix  = ""
  # Log format
  flow_log_log_format = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
  # flow log tags
  vpc_flow_log_tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  # VPN
  vpn_gateway_az   = null
  vpn_gateway_id   = ""
  vpn_gateway_tags = {}

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
