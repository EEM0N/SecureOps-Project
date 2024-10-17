data "tfe_workspace" "my_workspace" {
  name         = var.workspace_name
  organization = var.org_name
}
# The following variables must be set to allow runs
# to authenticate to AWS.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "enable_vault_provider_auth" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  description  = "Enable the Workload Identity integration for Vault."
}
resource "tfe_variable" "tfc_vault_addr" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_ADDR"
  value        = var.vault_url
  category     = "env"
  sensitive    = true
  description  = "The address of the Vault instance runs will access."
}
resource "tfe_variable" "tfc_vault_role" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_RUN_ROLE"
  value        = var.run_role
  category     = "env"
  description  = "The Vault role runs will use to authenticate."
}
resource "tfe_variable" "tfc_vault_namespace" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_NAMESPACE"
  value        = var.vault_namespace
  category     = "env"
  description  = "Namespace that contains the AWS Secrets Engine."
}

resource "tfe_variable" "aws_region" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "AWS_REGION"
  value        = var.aws_region
  category     = "env"

}