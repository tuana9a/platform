resource "aws_iam_role" "i_300_loki" {
  name               = "i-300-loki"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": {
        "Federated": "${data.aws_iam_openid_connect_provider.github.arn}"
      },
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:tuana9a/platform:*"
        },
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
EOT
}

resource "aws_iam_role_policy" "i_300_loki" {
  role   = aws_iam_role.i_300_loki.name
  name   = "i-300-loki"
  policy = data.aws_iam_policy_document.i_300_loki.json
}

data "aws_iam_policy_document" "i_300_loki" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateUser",
      "iam:GetUser",
      "iam:ListUsers",
      "iam:ListAccessKeys",
      "iam:ListAttachedUserPolicies",
      "iam:CreatePolicy",
      "iam:GetPolicy",
      "iam:ListPolicies",
      "iam:GetPolicyVersion",
    ]
    resources = ["*"]
  }
}
