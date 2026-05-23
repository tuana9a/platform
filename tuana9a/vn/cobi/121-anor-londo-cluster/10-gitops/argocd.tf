import {
  to = kubernetes_namespace_v1.argocd
  id = "argocd"
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

import {
  to = helm_release.argocd
  id = "argocd/argocd"
}


resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = kubernetes_namespace_v1.argocd.metadata[0].name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.9.1"

  values = [file("./manifests/argocd.values.yml")]
}
