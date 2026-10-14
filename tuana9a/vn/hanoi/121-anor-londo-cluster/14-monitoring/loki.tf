resource "helm_release" "loki" {
  name      = "loki"
  namespace = kubernetes_namespace_v1.grafana.metadata[0].name

  repository = "https://grafana-community.github.io/helm-charts"
  chart      = "loki"
  version    = "18.15.1"

  values = [
    templatefile("./loki-values.yaml", {})
  ]
}
