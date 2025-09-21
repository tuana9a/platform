resource "helm_release" "alertmanager" {
  name             = "alertmanager"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "alertmanager"
  version    = "1.26.0"

  values = [file("./values.yaml")]
}
