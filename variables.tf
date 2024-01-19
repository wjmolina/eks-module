variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "eks_managed_node_groups" {
  type    = map(any)
  default = { default = {} }
}
