resource "helm_release" "spegel" {
  name             = "spegel"
  namespace        = "spegel"
  create_namespace = true

  repository = "oci://ghcr.io/spegel-org/helm-charts"
  chart      = "spegel"
  version    = "0.3.0"

  set {
    name  = "spegel.resolveTags"
    value = "false"
  }

  set {
    name  = "spegel.resolveLatestTag"
    value = "false"
  }
}
