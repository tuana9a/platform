resource "kubernetes_manifest" "internal_service" {
  manifest = yamldecode(file("./manifests/internal-service.yaml"))
}