import {
  to = kubernetes_namespace_v1.metallb_system
  id = "metallb-system"
}

resource "kubernetes_namespace_v1" "metallb_system" {
  metadata {
    name = "metallb-system"
  }
}

import {
  to = helm_release.metallb
  id = "metallb-system/metallb"
}

resource "helm_release" "metallb" {
  name      = "metallb"
  namespace = kubernetes_namespace_v1.metallb_system.metadata[0].name

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.15.2"

  timeout = 60 * 10 # 10 mins
}

resource "kubernetes_manifest" "vmbr56_ipaddresspool" {
  depends_on = [helm_release.metallb]

  manifest = yamldecode(file("./manifests/vmbr56.IPAddressPool.yaml"))
}

resource "kubernetes_manifest" "vmbr56_l2advertisement" {
  depends_on = [helm_release.metallb]

  manifest = yamldecode(file("./manifests/vmbr56.L2Advertisement.yaml"))
}
