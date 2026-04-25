resource "aws_iam_role" "test_jenkins_oidc" {
  name               = "test-jenkins-oidc"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": {
        "Federated": "${data.aws_iam_openid_connect_provider.jenkins_tuana9a_com.arn}"
      },
      "Condition": {
        "StringLike": {
          "jenkins.tuana9a.com/oidc:sub": "https://jenkins.tuana9a.com/job/*"
        }
      }
    }
  ]
}
EOT
}

resource "aws_iam_role_policy" "test_jenkins_oidc" {
  role   = aws_iam_role.test_jenkins_oidc.name
  name   = "test-jenkins-oidc"
  policy = data.aws_iam_policy_document.test_jenkins_oidc_policy.json
}

data "aws_iam_policy_document" "test_jenkins_oidc_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = ["*"]
  }
}
