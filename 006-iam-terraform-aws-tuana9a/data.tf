data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_openid_connect_provider" "jenkins_tuana9a_com" {
  url = "https://jenkins.tuana9a.com/oidc"
}
