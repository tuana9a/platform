resource "aws_iam_role" "terraform_apply_300_loki" {
  name               = "terraform-apply-300-loki"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${aws_iam_role.github_workflow.arn}",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/ap-southeast-1/AWSReservedSSO_Admin_c31bf84842b4b2b9"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOT
}

resource "aws_iam_role_policy" "terraform_apply_300_loki" {
  role   = aws_iam_role.terraform_apply_300_loki.name
  name   = "terraform-apply-300-loki"
  policy = data.aws_iam_policy_document.terraform_apply_300_loki.json
}

data "aws_iam_policy_document" "terraform_apply_300_loki" {
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
      "iam:DetachUserPolicy",
      "iam:ListPolicyVersions",
      "iam:AttachUserPolicy",
      "iam:DeletePolicy",
    ]
    resources = ["*"]
  }
}
