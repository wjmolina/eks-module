provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  azs                     = ["us-west-1a", "us-west-1b"] # The control plane needs at least two.
  cidr                    = "10.0.0.0/16"
  private_subnets         = ["10.0.0.0/24", "10.0.1.0/24"] # See azs.
  public_subnets          = ["10.0.2.0/24"]
  map_public_ip_on_launch = true # Nodes provisioned in public subnets require it.
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name                   = "eks-example"
  vpc_id                         = module.vpc.vpc_id
  control_plane_subnet_ids       = module.vpc.private_subnets
  subnet_ids                     = module.vpc.public_subnets
  cluster_endpoint_public_access = true # It enables local kubectl.

  eks_managed_node_groups = {
    default = {}
  }
}
