resource "vault_aws_secret_backend" "aws" {
  access_key = aws_iam_access_key.vault_admin.id
  secret_key = aws_iam_access_key.vault_admin.secret
  region = "ap-southeast-1"
  path = "aws-dev"
  default_lease_ttl_seconds = 900
  max_lease_ttl_seconds = 1500
}

resource "vault_aws_secret_backend_role" "role" {
  backend = vault_aws_secret_backend.aws.path
  name    = "admin-access-role"
  credential_type = "iam_user"

  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

data "vault_aws_access_credentials" "creds" {
  backend = vault_aws_secret_backend.aws.path
  role    = vault_aws_secret_backend_role.role.name
}