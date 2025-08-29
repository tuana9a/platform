resource "helm_release" "metallb" {
  name             = "metallb"
  namespace        = "metallb-system"
  create_namespace = true

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.15.2"
}
