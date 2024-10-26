output "hvn_id" {
  description = "HCP HVN ID"
  value = hcp_hvn.vault_hvn
}

output "vault_id" {
  description = "HCP Vault Cluster ID"
  value = hcp_vault_cluster.vault_cluster.id
}

output "vault_namespace" {
  description = "HCP Vault Cluster Namespace"
  value = hcp_vault_cluster.vault_cluster.namespace
}

output "vault_public_endpoint_url" {
  description = "HCP Vault Cluster Vault Public Endpoint URL"
  value = hcp_vault_cluster.vault_cluster.vault_public_endpoint_url
}

output "vault_version" {
  description = "HCP Vault Cluster's Vault Version"
  value = hcp_vault_cluster.vault_cluster.vault_version
}

output "vault_private_endpoint_url" {
  description = "HCP Vault Cluster's Vault Private Endpoint URL"
  value = hcp_vault_cluster.vault_cluster.vault_private_endpoint_url
}

output "hvn_cidr" {
  description = "HCP Vault Cluster's CIDR"
  value = hcp_hvn.vault_hvn.cidr_block
}