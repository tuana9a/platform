data "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}