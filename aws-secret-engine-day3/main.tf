# Configure the AWS secret backend in Vault with access and secret keys
resource "vault_aws_secret_backend" "aws" {
  access_key = aws_iam_access_key.vault_admin.id
  secret_key = aws_iam_access_key.vault_admin.secret
  region     = "ap-southeast-1"
  path       = "aws-dev"
  
  # Set default and maximum lease durations for AWS credentials
  default_lease_ttl_seconds = 900
  max_lease_ttl_seconds     = 1500
}

# Define a role within the AWS secret backend that grants admin access
resource "vault_aws_secret_backend_role" "role" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "admin-access-role"
  credential_type = "iam_user"
  
  # Attach the AdministratorAccess policy to the role
  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "time_sleep" "wait_before_creating_role" {
  depends_on      = [vault_aws_secret_backend_role.role]
  create_duration = "60s"
}


# Fetch AWS access credentials for the defined role from Vault
data "vault_aws_access_credentials" "creds" {
  depends_on               = [time_sleep.wait_before_creating_role]
  backend = vault_aws_secret_backend.aws.path
  role    = vault_aws_secret_backend_role.role.name
}
