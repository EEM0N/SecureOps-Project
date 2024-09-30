output "aws_auth_role_name" {
  value = vault_aws_auth_backend_role.aws.role_id
}