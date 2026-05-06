resource "helm_release" "loki" {
  name      = "loki"
  namespace = kubernetes_namespace_v1.grafana.metadata[0].name

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.10.2"

  values = [
    templatefile("./loki.yaml", {})
  ]
}
