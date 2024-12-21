resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.20.1"

  values = [
    file("./values.yaml"),
    file("./alertmanager-values.yaml"),
    file("./alert-values.yaml"),
  ]
}
