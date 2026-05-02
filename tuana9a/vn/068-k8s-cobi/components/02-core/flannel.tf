import {
  to = kubernetes_namespace_v1.kube_flannel
  id = "kube-flannel"
}

resource "kubernetes_namespace_v1" "kube_flannel" {
  metadata {
    name = "kube-flannel"
  }
}

# resource "helm_release" "flannel" {
#   name      = "flannel"
#   namespace = kubernetes_namespace_v1.kube_flannel.metadata[0].name

#   repository = "https://flannel-io.github.io/flannel"
#   chart      = "flannel"
#   version    = "v0.25.1"

#   values = [file("./flannel.yaml")]
# }
