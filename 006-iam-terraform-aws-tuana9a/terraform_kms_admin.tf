resource "aws_iam_role" "terraform_kms_admin" {
  name               = "terraform-kms-admin"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.github_workflow.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOT
}

resource "aws_iam_role_policy" "terraform_kms_admin" {
  role   = aws_iam_role.terraform_kms_admin.name
  name   = "terraform-kms-admin"
  policy = data.aws_iam_policy_document.terraform_kms_admin_policy.json
}

data "aws_iam_policy_document" "terraform_kms_admin_policy" {
  statement {
    sid    = "AllKMS"
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }
}
