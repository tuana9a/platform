import {
  to = kubernetes_namespace_v1.ingress_nginx
  id = "ingress-nginx"
}

resource "kubernetes_namespace_v1" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

import {
  to = helm_release.ingress_nginx
  id = "ingress-nginx/ingress-nginx"
}

resource "helm_release" "ingress_nginx" {
  name      = "ingress-nginx"
  namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.12.1"

  values = [file("./ingress-nginx.yaml")]
}
