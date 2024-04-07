resource "helm_release" "nfs_provisioner" {
  name             = "nfs-subdir-external-provisioner"
  namespace        = "nfs-provisioner"
  create_namespace = true

  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner"
  chart      = "nfs-subdir-external-provisioner"
  version    = "4.0.18"

  set {
    name  = "nfs.server"
    value = "192.168.56.7"
  }

  set {
    name  = "nfs.path"
    value = "/exports/nfs-client"
  }
}
