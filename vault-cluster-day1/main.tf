resource "hcp_hvn" "vault_hvn" {
  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.aws_region
  cidr_block     = var.cidr
}

resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id = var.cluster_id
  hvn_id     = hcp_hvn.vault_hvn.hvn_id
  tier       = var.tier
  public_endpoint = true
}