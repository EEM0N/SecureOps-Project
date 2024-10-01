variable "workspace_name" {
  description = "Workspace Name"
  type = string
  default = "enable-aws-auth-on-vault-day6"
}
variable "org_name" {
  description = "Organization Name"
  type = string
  default = "hellocloud-eem"
}
variable "vault_url" {
  description = "The address of the Vault instance runs will access."
  type = string
  default = "https://vault-cluster-id-public-vault-2a5d42b2.18e736ba.z1.hashicorp.cloud:8200" ### have to change new vault cluster id
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
variable "aws_region" {
  description = "AWS_REGION"
  type = string
  default = "ap-southeast-1"
}
variable "tfc_vault_backed_aws_auth" {
  description = "TFC_VAULT_BACKED_AWS_AUTH"
  type = string
  default = "true"
}
variable "tfc_vault_backed_aws_auth_type" {
  description = "TFC_VAULT_BACKED_AWS_AUTH_TYPE "
  type = string
  default = "iam_user"
}
variable "tfc_vault_backed_aws_run_vault_role" {
  description = "TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE"
  type = string
  default = "admin-access-role"
}
variable "tfc_vault_backed_aws_mount_path" {
  description = "TFC_VAULT_BACKED_AWS_MOUNT_PATH"
  type = string
  default = "aws-dev"
}