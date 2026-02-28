# resource "helm_release" "calico" {
#   name             = "calico"
#   namespace        = "tigera-operator"
#   create_namespace = true

#   repository = "https://docs.tigera.io/calico/charts"
#   chart      = "tigera-operator"
#   version    = "v3.30.6"

#   values = [file("./values.yml")]

#   timeout = 30 * 60
# }
