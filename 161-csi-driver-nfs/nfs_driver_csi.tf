# resource "helm_release" "csi_driver_nfs" {
#   name      = "csi-driver-nfs"
#   namespace = "csi-driver-nfs"

#   create_namespace = true

#   repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
#   chart      = "csi-driver-nfs"
#   version    = "4.11.0"
# }
