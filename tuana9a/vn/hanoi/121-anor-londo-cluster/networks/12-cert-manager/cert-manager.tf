import {
  to = kubernetes_namespace_v1.cert_manager
  id = "cert-manager"
}

resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

import {
  to = helm_release.cert_manager
  id = "cert-manager/cert-manager"
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.21.1"

  values = [file("./values.yaml")]
}
