resource "kubernetes_secret" "all_secrets" {
  for_each = var.secrets
  metadata {
    namespace = var.namespace
    name      = each.key
  }
  type = "Opaque"
  data = each.value
}
