# Introduction
This Terraform module creates an EKS cluster and a VPC using AWS modules. The VPC should create at least two private subnets, each in different availability zones, and at least one public subnet that assigns public IP addresses to EC2 instances. The EKS control plane is deployed in the private subnets, and an EKS-managed node group is deployed in the public subnets.
# Versions
- Terraform v1.7.0
