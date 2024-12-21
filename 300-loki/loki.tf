resource "helm_release" "loki" {
  name             = "loki"
  namespace        = "loki-system"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.10.2"

  values = [file("./values.yaml")]
}
