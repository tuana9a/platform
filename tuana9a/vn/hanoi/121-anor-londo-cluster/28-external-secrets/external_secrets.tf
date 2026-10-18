import {
  to = kubernetes_namespace_v1.external_secrets
  id = "external-secrets"
}

resource "kubernetes_namespace_v1" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

import {
  to = helm_release.external_secrets
  id = "external-secrets/external-secrets"
}

resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  namespace        = kubernetes_namespace_v1.external_secrets.metadata[0].name
  create_namespace = false

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.11.0"
}
