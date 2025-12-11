# resource "helm_release" "nfs_subdir_external_provisioner" {
#   name             = "nfs-subdir-external-provisioner"
#   namespace        = "nfs-subdir-external-provisioner"
#   create_namespace = true

#   repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
#   chart      = "nfs-subdir-external-provisioner"
#   version    = "4.0.18"

#   values = [file("./values.yaml")]
# }
