resource "helm_release" "kube_state_metrics" {
  name             = "kube-state-metrics"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"
  version    = "6.3.0"
}
