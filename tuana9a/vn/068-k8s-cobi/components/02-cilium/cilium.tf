resource "kubernetes_namespace_v1" "cilium_system" {
  metadata {
    name = "cilium-system"
  }
}

resource "helm_release" "cilium" {
  name      = "cilium"
  namespace = kubernetes_namespace_v1.cilium_system.metadata[0].name

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.19.1"
  values     = [file("./values.yml")]

  timeout = 10 * 60
}
