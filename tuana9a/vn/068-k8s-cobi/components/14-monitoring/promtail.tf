import {
  to = kubernetes_namespace_v1.promtail
  id = "promtail"
}

resource "kubernetes_namespace_v1" "promtail" {
  metadata {
    name = "promtail"
  }
}

import {
  to = helm_release.promtail
  id = "promtail/promtail"
}

resource "helm_release" "promtail" {
  name      = "promtail"
  namespace = kubernetes_namespace_v1.promtail.metadata[0].name

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.16.6"

  values = [file("./promtail.yaml")]
}
