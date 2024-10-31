# Create an IAM user for the Vault admin
resource "aws_iam_user" "vault_admin" {
  name = var.vault_admin
  path = "/"

  tags = {
    Name = "vault-admin"
  }
}

# Create an access key for the Vault admin user
resource "aws_iam_access_key" "vault_admin" {
  user = aws_iam_user.vault_admin.name
}

# Define the IAM policy document for the Vault admin user
data "aws_iam_policy_document" "vault_admin" {
  statement {
    effect    = "Allow"
    actions   = [
        "iam:AttachUserPolicy",
        "iam:CreateUser",
        "iam:CreateAccessKey",
        "iam:DeleteUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:GetUser",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup"
    ]
    resources = [
      "arn:aws:iam::xxxxxxxxxxxx:user/vault-*"
    ]
  }
}

# Attach the defined policy to the Vault admin user
resource "aws_iam_user_policy" "vault_admin" {
  name   = "vault-admin-policy"
  user   = aws_iam_user.vault_admin.name
  policy = data.aws_iam_policy_document.vault_admin.json
}
