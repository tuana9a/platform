resource "helm_release" "longhorn" {
  name             = "longhorn"
  namespace        = "longhorn-system"
  create_namespace = true

  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.7.0"
}
