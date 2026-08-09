data "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}

# for using with clustersecretstore so we don't use any static token anymore
resource "kubernetes_service_account_v1" "vault_secret_operator" {
  metadata {
    name      = "vault-secret-operator"
    namespace = data.kubernetes_namespace_v1.vault.metadata[0].name
  }
}
