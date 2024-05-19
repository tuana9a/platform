resource "helm_release" "flannel" {
  name             = "flannel"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://flannel-io.github.io/flannel"
  chart      = "flannel"
  version    = "v0.25.1"

  values = [file("./values.yaml")]
}
