import {
  to = kubernetes_namespace_v1.metrics_server
  id = "metrics-server"
}

resource "kubernetes_namespace_v1" "metrics_server" {
  metadata {
    name = "metrics-server"
  }
}

import {
  to = helm_release.metrics_server
  id = "metrics-server/metrics-server"
}

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = kubernetes_namespace_v1.metrics_server.metadata[0].name

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.12.0"

  set {
    name  = "replicas"
    value = "3"
  }

  set_list {
    name  = "args"
    value = ["--kubelet-insecure-tls"]
  }
}
