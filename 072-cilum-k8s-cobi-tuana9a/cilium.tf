resource "helm_release" "cilium" {
  name      = "cilium"
  namespace = "kube-system"

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.19.1"
  values     = [file("./values.yml")]

  timeout = 10 * 60
}
