import {
  to = kubernetes_namespace_v1.wireguard
  id = "wireguard"
}

resource "kubernetes_namespace_v1" "wireguard" {
  metadata {
    name   = "wireguard"
    labels = local.wireguard.labels
  }
}