resource "aws_iam_openid_connect_provider" "jenkins_tuana9a_com" {
  url            = "https://jenkins.tuana9a.com/oidc"
  client_id_list = ["sts.amazonaws.com"]
}
