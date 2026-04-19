resource "kubernetes_secret_v1" "alertmanager" {
  metadata {
    name      = "alertmanager"
    namespace = "prometheus"
  }

  data = {
    "telegram_bot_token.txt" = local.secrets.telegram_bot_token
  }
}

resource "helm_release" "alertmanager" {
  depends_on = [kubernetes_secret_v1.alertmanager]

  name             = "alertmanager"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "alertmanager"
  version    = "1.30.0"

  values = [file("./values.yaml")]
}
