variable "hvn_id" {
  type    = string
  default = "secureops-project-network-for-vault-cluster"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "cloud_provider" {
  type    = string
  default = "aws"
}

variable "hcp_cidr" {
  type    = string
  default = "172.25.16.0/20"
}

variable "cluster_id" {
  type    = string
  default = "secureops-project-vault-cluster-id"
}

variable "tier" {
  type    = string
  default = "starter_small"
}

variable "public_endpoint" {
  type    = bool
  default = true
}
