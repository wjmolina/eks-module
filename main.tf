data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" { state = "available" }

resource "aws_iam_role" "ebs_csi_iam_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com",
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  azs                     = slice(data.aws_availability_zones.available.names, 0, 2)
  cidr                    = "10.0.0.0/16"
  private_subnets         = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets          = ["10.0.2.0/24"]
  map_public_ip_on_launch = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name                   = "eks-example"
  vpc_id                         = module.vpc.vpc_id
  control_plane_subnet_ids       = module.vpc.private_subnets
  subnet_ids                     = module.vpc.public_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {}
  }

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = aws_iam_role.ebs_csi_iam_role.arn
    }
  }
}
