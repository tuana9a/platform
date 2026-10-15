# https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy

resource "aws_iam_role" "upload_tuana9a_web" {
  name               = "upload-tuana9a-web"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.github.arn}"
      },
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:tuana9a@53028317/web@1132589135:*"
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

resource "aws_iam_role_policy" "upload_tuana9a_web" {
  role   = aws_iam_role.upload_tuana9a_web.name
  name   = "upload-tuana9a-web"
  policy = data.aws_iam_policy_document.upload_tuana9a_web.json
}

data "aws_iam_policy_document" "upload_tuana9a_web" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = ["arn:aws:s3:::tuana9a.com/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket", ]
    resources = ["arn:aws:s3:::tuana9a.com"]
  }
}
