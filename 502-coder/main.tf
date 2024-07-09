resource "helm_release" "coder" {
  name             = "coder"
  namespace        = "coder"
  create_namespace = true

  repository = "https://helm.coder.com/v2"
  chart      = "coder"
  version    = "2.12.3"

  values = [
    "${file("./values.yaml")}"
  ]
}
