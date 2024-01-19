terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = var.default_tags
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name                           = var.vpc_name
  azs                            = var.availability_zones
  cidr                           = var.cidr
  private_subnets                = var.private_subnets
  public_subnets                 = var.public_subnets
  default_security_group_ingress = var.default_security_group_ingress
  map_public_ip_on_launch        = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name                   = var.cluster_name
  vpc_id                         = module.vpc.vpc_id
  control_plane_subnet_ids       = module.vpc.private_subnets
  subnet_ids                     = module.vpc.public_subnets
  cluster_endpoint_public_access = true
  eks_managed_node_groups        = var.eks_managed_node_groups
}
