# https://kubernetes.github.io/ingress-nginx/deploy/
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}
