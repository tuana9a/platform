locals {
  vmbr56_yaml = templatefile("./vmbr56.yaml", { namespace = kubernetes_namespace_v1.metallb_system.metadata[0].name })
  vmbr56_manifests = {
    for i, x in split("---", local.vmbr56_yaml) :
    i => yamldecode(x)
  }
}

moved {
  from = kubernetes_manifest.vmbr56_ipaddresspool
  to   = kubernetes_manifest.vmbr56["0"]
}

moved {
  from = kubernetes_manifest.vmbr56_l2advertisement
  to   = kubernetes_manifest.vmbr56["1"]
}

resource "kubernetes_manifest" "vmbr56" {
  depends_on = [helm_release.metallb]

  for_each = local.vmbr56_manifests

  manifest = each.value
}
