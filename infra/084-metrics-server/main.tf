resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.12.0"

  values = [
    "${file("./values.yaml")}"
  ]
}
