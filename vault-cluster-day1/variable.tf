variable "hvn_id" {
  type    = string
  default = "cohort7"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "cloud_provider" {
  type    = string
  default = "aws"
}

variable "cidr" {
  type    = string
  default = "172.25.16.0/20"
}

variable "cluster_id" {
  type    = string
  default = "cohort7-vault-cluster"
}

variable "tier" {
  type    = string
  default = "starter_small"
}