resource "kubernetes_namespace_v1" "falco" {
  metadata {
    name = "falco"
  }
}

resource "helm_release" "falco" {
  name      = "falco"
  namespace = kubernetes_namespace_v1.falco.metadata[0].name

  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  version    = "8.0.3"

  set {
    name  = "tty"
    value = "true"
  }
}
