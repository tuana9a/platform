resource "helm_release" "coder" {
  name             = "coder"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://helm.coder.com/v2"
  chart      = "coder"
  version    = "2.10.1"

  values = [
    "${file("./values.yaml")}"
  ]
}
