resource "helm_release" "prometheus_pushgateway" {
  name             = "prometheus-pushgateway"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-pushgateway"
  version    = "2.12.0"

  values = [file("./values.yaml")]
}
