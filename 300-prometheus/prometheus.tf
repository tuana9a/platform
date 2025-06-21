resource "kubernetes_manifest" "alertmanager_secret" {
  manifest = yamldecode(file("./manifests/alertmanager-secret.yaml"))
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.20.1"

  values = [file("./values.yaml")]

  depends_on = [kubernetes_manifest.alertmanager_secret]
}
