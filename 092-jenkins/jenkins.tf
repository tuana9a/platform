resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  create_namespace = true

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.10"

  values = [
    file("./values.yml"),
    file("./oidc-values.yml"),
    file("./test-oidc-values.yml"),
  ]
}
