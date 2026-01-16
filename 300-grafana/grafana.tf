resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "10.5.8"

  values = [file("./values.yaml")]
}

resource "kubernetes_manifest" "datasources" {
  manifest   = yamldecode(file("./datasources.yaml"))
  depends_on = [helm_release.grafana]
}
