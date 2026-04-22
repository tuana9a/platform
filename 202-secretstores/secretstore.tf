resource "kubernetes_secret_v1" "clustersecretstore_vault_tuana9a_com" {
  metadata {
    namespace = "vault"
    name      = "clustersecretstore-vault-tuana9a-com"
  }

  data = {
    VAULT_TOKEN = local.secrets.clustersecretstore.vault-tuana9a-com.VAULT_TOKEN
  }
}

resource "kubernetes_manifest" "jcasc" {
  depends_on = [kubernetes_secret_v1.clustersecretstore_vault_tuana9a_com]

  for_each = fileset("./manifests", "*")

  manifest = yamldecode(file("./manifests/${each.key}"))
}
