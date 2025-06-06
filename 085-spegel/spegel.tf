# resource "helm_release" "spegel" {
#   name             = "spegel"
#   namespace        = "spegel"
#   create_namespace = true

#   repository = "oci://ghcr.io/spegel-org/helm-charts"
#   chart      = "spegel"
#   version    = "v0.0.28"
# }
