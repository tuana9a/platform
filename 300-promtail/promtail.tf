resource "helm_release" "promtail" {
  name             = "promtail"
  namespace        = "promtail"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.16.6"

  values = [file("./values.yaml")]
}
