import {
  to = helm_release.node_exporter
  id = "prometheus/prometheus-node-exporter"
}

resource "helm_release" "node_exporter" {
  name      = "prometheus-node-exporter"
  namespace = kubernetes_namespace_v1.prometheus.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-node-exporter"
  version    = "4.48.0"
}
