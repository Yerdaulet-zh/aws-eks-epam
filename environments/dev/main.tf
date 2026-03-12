module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  # VPC
  create_vpc              = true
  name                    = "eks-vpc-epam"
  cidr                    = "10.0.0.0/16"
  use_ipam_pool           = false
  enable_dns_support      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  # AZs
  azs = ["eu-central-1a", "eu-central-1b"]

  # IPv4 SUBNETS
  database_subnets    = ["10.0.21.0/24", "10.0.22.0/24"]
  elasticache_subnets = ["10.0.31.0/24", "10.0.32.0/24"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  redshift_subnets    = ["10.0.41.0/24", "10.0.42.0/24"]
  intra_subnets       = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]

  # SUBNET GROUPS
  # cache
  create_elasticache_subnet_group = true
  # database
  create_database_subnet_group = true

  # SUBNET ROUTE TABLE
  # cache
  create_elasticache_subnet_route_table = true
  # database
  create_database_subnet_route_table = false # internal vpc communication is enabled

  # INTERNET GATEWAY
  create_igw             = true
  create_egress_only_igw = true # IPv6 does not use NAT, gloabally unique IP addresses
  # database gateway
  create_database_internet_gateway_route = false # disable vpc internet access to rds subnets

  # NAT GATEWAY
  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  # database nat gateway
  create_database_nat_gateway_route = false

  # NETWORK SECURITY
  # VPC ACL
  manage_default_network_acl = true
  # Global Kill Switch: Total isolation for the VPC
  vpc_block_public_access_options = {
    internet_gateway_block_mode = "block-bidirectional"
  }
  # Exeptions from Total VPC isolation
  vpc_block_public_access_exclusions = {
    "public_0" = {
      internet_gateway_exclusion_mode = "allow-bidirectional"
      subnet_type                     = "public"
      subnet_index                    = 0
      exclude_subnet                  = true  # Explicitly tell the module this is for a subnet
      exclude_vpc                     = false # Ensure it doesn't try to apply to the whole VPC
    }
    "public_1" = {
      internet_gateway_exclusion_mode = "allow-bidirectional"
      subnet_type                     = "public"
      subnet_index                    = 1
      exclude_subnet                  = true
      exclude_vpc                     = false
    }
    "public_2" = {
      internet_gateway_exclusion_mode = "allow-bidirectional"
      subnet_type                     = "public"
      subnet_index                    = 2
      exclude_subnet                  = true
      exclude_vpc                     = false
    }
  }

  # REDSHIFT
  enable_public_redshift = false

  # VPN
  vpn_gateway_az   = null
  vpn_gateway_id   = ""
  vpn_gateway_tags = {}

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
