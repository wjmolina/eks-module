# Introduction
This Terraform module creates an EKS cluster and a VPC using AWS modules. The VPC should create at least two private subnets, each in different availability zones, and at least one public subnet that assigns public IP addresses to EC2 instances. The EKS control plane is deployed in the private subnets, and an EKS-managed node group is deployed in the public subnets. Additionally, an EBS CSI driver is added to the cluster to enable it to provision persistent volumes.
# Version
Terraform v1.6.2
# Issues
The `aws_eks_addon` warning is being tracked in [this issue](https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2635).