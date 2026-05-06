resource "helm_release" "promtail" {
  name      = "promtail"
  namespace = kubernetes_namespace_v1.grafana.metadata[0].name

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.16.6"

  values = [file("./promtail.yaml")]
}
