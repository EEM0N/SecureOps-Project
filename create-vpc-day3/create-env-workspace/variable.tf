variable "workspace_name" {
  description = "Workspace Name"
  type = string
  default = "create-vpc-day3"
}
variable "org_name" {
  description = "Organization Name"
  type = string
  default = "hellocloud-eem"
}
variable "vault_url" {
  description = "The address of the Vault instance runs will access."
  type = string
  default = "https://vault-cluster-id-public-vault-389205e7.789030d1.z1.hashicorp.cloud:8200" ### have to change new vault cluster id
}
variable "run_role" {
  description = "TFC_VAULT_RUN_ROLE"
  type = string
  default = "admin-role"
}
variable "vault_namespace" {
  description = "TFC_VAULT_NAMESPACE"
  type = string
  default = "admin"
}