resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  namespace        = "metrics-server"
  create_namespace = true

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.12.0"

  set_list {
    name  = "args"
    value = ["--kubelet-insecure-tls"]
  }
}
