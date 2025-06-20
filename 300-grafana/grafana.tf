resource "kubernetes_manifest" "admin_login_secret" {
  manifest = yamldecode(file("./manifests/admin-login-secret.yaml"))
}

resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.6.4"

  values = [file("./values.yaml")]

  depends_on = [kubernetes_manifest.admin_login_secret]
}

resource "kubernetes_manifest" "datasources" {
  manifest = yamldecode(file("./manifests/datasources.yaml"))
}
