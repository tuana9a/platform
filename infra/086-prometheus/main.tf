locals {
  namespace = "prometheus"
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = local.namespace
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.20.1"

  values = [
    "${file("./prometheus-values.yaml")}"
  ]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = local.namespace
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.10"

  values = [
    "${file("./grafana-values.yaml")}"
  ]
}
