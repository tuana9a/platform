resource "aws_iam_role" "terraform_iam_admin" {
  name               = "terraform-iam-admin"
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

resource "aws_iam_role_policy" "terraform_iam_admin" {
  role   = aws_iam_role.terraform_iam_admin.name
  name   = "terraform-iam-admin"
  policy = data.aws_iam_policy_document.terraform_iam_admin_policy.json
}

data "aws_iam_policy_document" "terraform_iam_admin_policy" {
  statement {
    sid    = "AllIAM"
    effect = "Allow"
    actions = [
      "iam:*",
    ]
    resources = ["*"]
  }
}
