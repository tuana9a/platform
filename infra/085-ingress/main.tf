resource "helm_release" "ingress_nginx" {
  # https://kubernetes.github.io/ingress-nginx/deploy/
  name             = "ingress-nginx"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}