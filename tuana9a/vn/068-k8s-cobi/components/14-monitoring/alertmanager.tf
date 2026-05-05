import {
  to = kubernetes_secret_v1.alertmanager
  id = "prometheus/alertmanager"
}

resource "kubernetes_secret_v1" "alertmanager" {
  metadata {
    name      = "alertmanager"
    namespace = kubernetes_namespace_v1.prometheus.metadata[0].name
  }

  data = {
    "telegram_bot_token.txt" = local.secrets.alertmanager.telegram_bot_token
  }
}

import {
  to = helm_release.alertmanager
  id = "prometheus/alertmanager"
}

resource "helm_release" "alertmanager" {
  depends_on = [kubernetes_secret_v1.alertmanager]

  name      = "alertmanager"
  namespace = kubernetes_namespace_v1.prometheus.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "alertmanager"
  version    = "1.30.0"

  values = [file("./alertmanager.yaml")]
}
