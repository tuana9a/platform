resource "kubernetes_namespace_v1" "gateway" {
  metadata {
    name = "gateway"
  }
}
