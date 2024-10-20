output "aws_auth_role_name" {
  value = vault_aws_auth_backend_role.aws.role_id
}

output "instance_profile_id" {
  value = aws_iam_instance_profile.profile_for_ec2_role.id
}