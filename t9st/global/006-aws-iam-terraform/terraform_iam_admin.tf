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
          "arn:aws:iam::${local.aws_accounts.tuana9a.id}:root"
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
