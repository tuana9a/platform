resource "aws_iam_openid_connect_provider" "jenkins_tuana9a_com" {
  url            = "https://jenkins.tuana9a.com/oidc"
  client_id_list = ["sts.amazonaws.com"]
}

import {
  to = aws_iam_openid_connect_provider.jenkins_tuana9a_com
  id = "arn:aws:iam::384588864907:oidc-provider/jenkins.tuana9a.com/oidc"
}