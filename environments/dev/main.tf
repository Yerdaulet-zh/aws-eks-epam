module "vpc" {
  source = "../../modules/vpc"

  project_name = "aws-eks-epam"
  region       = "eu-central-1"
  vpc_cidr     = "10.1.0.0/16"

  subnets = {
    "public_a"  = { cidr = "10.1.1.0/24", az = "a", public = true, usage = "elb" }
    "public_b"  = { cidr = "10.1.2.0/24", az = "b", public = true, usage = "elb" }
    "private_a" = { cidr = "10.1.16.0/20", az = "a", public = false, usage = "internal-elb" }
    "private_b" = { cidr = "10.1.32.0/20", az = "b", public = false, usage = "internal-elb" }
    "db_a"      = { cidr = "10.1.50.0/24", az = "a", public = false, usage = "storage" }
  }
}
