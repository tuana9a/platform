import {
  to = helm_release.kube_state_metrics
  id = "prometheus/kube-state-metrics"
}

resource "helm_release" "kube_state_metrics" {
  name      = "kube-state-metrics"
  namespace = kubernetes_namespace_v1.prometheus.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"
  version    = "6.3.0"
}
