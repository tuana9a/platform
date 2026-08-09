import {
  to = kubernetes_namespace_v1.vault
  id = "vault"
}

resource "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "vault" {
  name      = "vault"
  namespace = kubernetes_namespace_v1.vault.metadata[0].name

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.28.1"

  values = [file("./values.yaml")]
}
