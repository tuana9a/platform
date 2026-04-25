resource "aws_iam_role" "jenkins_job" {
  name               = "jenkins-job"
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
