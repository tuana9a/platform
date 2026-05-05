import {
  to = kubernetes_namespace_v1.prometheus
  id = "prometheus"
}

resource "kubernetes_namespace_v1" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

import {
  to = helm_release.prometheus
  id = "prometheus/prometheus"
}

resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = kubernetes_namespace_v1.prometheus.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.20.1"

  values = [file("./prometheus.yaml")]

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-node-exporter.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-pushgateway.enabled"
    value = "false"
  }
}
