import {
  to = helm_release.prometheus_pushgateway
  id = "prometheus/prometheus-pushgateway"
}

resource "helm_release" "prometheus_pushgateway" {
  name      = "prometheus-pushgateway"
  namespace = kubernetes_namespace_v1.prometheus.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-pushgateway"
  version    = "2.12.0"

  values = [file("./prometheus-pushgateway.yaml")]
}
