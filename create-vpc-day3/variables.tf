variable "vpc_name" {
  description = "The name of the VPC."
  default     = "app-vpc"
}
variable "public_cidr_block" {
  default = ["10.10.1.0/24", "10.10.2.0/24","10.10.3.0/24"]
}

variable "private_cidr_block" {
  default = ["10.10.4.0/24", "10.10.5.0/24","10.10.6.0/24"]
}

variable "db_cidr_block" {
  default = ["10.10.7.0/24", "10.10.8.0/24","10.10.9.0/24"]
}