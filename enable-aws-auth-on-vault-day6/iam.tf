resource "aws_iam_user" "aws_auth_admin" {
  name = "aws-auth-admin"
  path = "/"

}

resource "aws_iam_access_key" "aws_auth_admin_key" {
  user = aws_iam_user.aws_auth_admin.name
}

data "aws_iam_policy_document" "aws_auth_admin_policy_doc" {
  statement {
    sid    = "VaultAWSAuthMethod"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:ListRoles",
      "iam:GetRole"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_user_policy" "aws_auth_admin_policy" {
  name   = "aws-auth-policy"
  user   = aws_iam_user.aws_auth_admin.name
  policy = data.aws_iam_policy_document.aws_auth_admin_policy_doc.json
}

##Create IAM Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "AWS_EC2_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "profile_for_ec2_role" {
  name = "vault-client-instance-profile"
  role = aws_iam_role.ec2_role.id
}