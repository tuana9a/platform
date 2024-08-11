resource "kubernetes_namespace" "csi_proxmox" {
  metadata {
    name = "csi-proxmox"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "proxmox_csi_plugin" {
  name             = "proxmox-csi-plugin"
  namespace        = kubernetes_namespace.csi_proxmox.id
  create_namespace = false

  repository = "oci://ghcr.io/sergelogvinov/charts"
  chart      = "proxmox-csi-plugin"
  version    = "0.2.5"

  values = [
    "${file("./values.yml")}",
    "${file("./values.secret.yml")}"
  ]
}
