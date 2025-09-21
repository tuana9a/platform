resource "helm_release" "node_exporter" {
  name             = "prometheus-node-exporter"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-node-exporter"
  version    = "4.48.0"
}
