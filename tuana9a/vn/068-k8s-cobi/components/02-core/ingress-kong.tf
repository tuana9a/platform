import {
  to = kubernetes_namespace_v1.ingress_kong
  id = "ingress-kong"
}

resource "kubernetes_namespace_v1" "ingress_kong" {
  metadata {
    name = "ingress-kong"
  }
}

import {
  to = helm_release.ingress_kong
  id = "ingress-kong/ingress-kong"
}

resource "helm_release" "ingress_kong" {
  name      = "ingress-kong"
  namespace = kubernetes_namespace_v1.ingress_kong.metadata[0].name

  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = "2.42.0"

  values = [file("./ingress-kong.yaml")]
}
