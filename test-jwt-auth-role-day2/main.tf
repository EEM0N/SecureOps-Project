# Mount a new KV (Key-Value) secrets engine at the specified path
resource "vault_mount" "example" {
  path    = "example"
  type    = "kv-v2"
  options = { version = "2" }
}

# Create a secret in the KV secrets engine
resource "vault_kv_secret_v2" "example" {
  mount                = vault_mount.example.path
  name                 = "unsecret"
  cas                  = 1
  delete_all_versions  = true
  
  # Define the secret data to be stored in JSON format
  data_json = jsonencode(
    {
      foo                     = "bar",
      dynamic_provider_credential = "true",
      add_new_key_value       = "add_new"
    }
  )
}
