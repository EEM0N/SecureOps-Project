variable "role_name" {
  type    = string
  default = "admin-role"
}

variable "bound_audiences" {
  type    = string
  default = "vault.workload.identity"
}

variable "organization" {
  type    = string
  default = "hellocloud-eem"
}

variable "project" {
  type    = string
  default = "SecureOps-Project"
}

