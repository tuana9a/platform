resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.10"

  values = [
    "${file("./values.yaml")}"
  ]
}
