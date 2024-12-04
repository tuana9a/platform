resource "helm_release" "vault" {
  name             = "vault"
  namespace        = "vault"
  create_namespace = true

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.28.1"

  values = [file("./values.yaml")]
}
