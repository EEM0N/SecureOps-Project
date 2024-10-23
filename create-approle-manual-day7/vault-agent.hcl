#exit_after_auth = true
pid_file = "SecureOps-Project/create-approle-manual-day7/pidfile"
auto_auth {
   method "approle" {
       mount_path = "auth/approle"
       namespace = "admin"
       config = {
           role_id_file_path = "SecureOps-Project/create-approle-manual-day7/role_id"
           secret_id_file_path = "SecureOps-Project/create-approle-manual-day7/secret_id"
           remove_secret_id_file_after_reading = false
       }
   }
   sink "file" {
       config = {
           path = "SecureOps-Project/create-approle-manual-day7/vault_token"
       }
   }
}
vault {
   address = "https://vault-cluster-id-public-vault-2ca71c0f.ab12514b.z1.hashicorp.cloud:8200"
}
template_config {
  exit_on_retry_failure = true
  max_connections_per_host = 20
  lease_renewal_threshold = 0.90
}
template {
  source = "SecureOps-Project/create-approle-manual-day7/aws-tmpl.tmpl"
  destination  = "/tmp/agent/render-content.txt"
}
