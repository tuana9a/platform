resource "kubernetes_service_account_v1" "vault_maintenance" {
  metadata {
    name      = "vault-maintenance"
    namespace = data.kubernetes_namespace_v1.github_runners.metadata[0].name
  }
}
