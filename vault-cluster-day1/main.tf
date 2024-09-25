# Create a HVN (Hashicorp Virtual Network) in HCP
resource "hcp_hvn" "vault_hvn" {
  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.aws_region
  cidr_block     = var.hcp_cidr
}

# Create a Vault cluster within the specified HVN
resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id      = var.cluster_id
  hvn_id          = hcp_hvn.vault_hvn.hvn_id
  tier            = var.tier
  public_endpoint = var.public_endpoint
}
