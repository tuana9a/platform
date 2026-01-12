data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy

resource "aws_iam_role" "upload_s3_tuana9a_com" {
  name               = "upload-s3-tuana9a-com"
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
          "token.actions.githubusercontent.com:sub": "repo:tuana9a/tuana9a.com:*"
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

resource "aws_iam_role_policy" "upload_s3_tuana9a_com" {
  role   = aws_iam_role.upload_s3_tuana9a_com.name
  name   = "upload-s3-tuana9a-com"
  policy = data.aws_iam_policy_document.upload_s3_tuana9a_com.json
}

data "aws_iam_policy_document" "upload_s3_tuana9a_com" {
  statement {
    sid    = "AllowS3Upload"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.tuana9a_com.bucket}/*"]
  }
  statement {
    sid       = "AllowBucketListing"
    effect    = "Allow"
    actions   = ["s3:ListBucket", ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.tuana9a_com.bucket}"]
  }
}
