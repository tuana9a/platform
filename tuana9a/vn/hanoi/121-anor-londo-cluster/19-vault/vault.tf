import {
  to = kubernetes_namespace_v1.vault
  id = "vault"
}

resource "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_manifest" "vault_listenterset" {
  manifest = yamldecode(templatefile("./vault-listenerset.yml", { namespace = kubernetes_namespace_v1.vault.metadata[0].name }))
}

resource "helm_release" "vault" {
  name      = "vault"
  namespace = kubernetes_namespace_v1.vault.metadata[0].name

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.34.1"

  values = [file("./values.yaml")]
}
