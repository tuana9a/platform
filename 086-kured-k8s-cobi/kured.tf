resource "helm_release" "kured" {
  name             = "kured"
  namespace        = "kured"
  create_namespace = true

  repository = "oci://ghcr.io/kubereboot/charts"
  chart      = "kured"
  version    = "5.10.0"
}
