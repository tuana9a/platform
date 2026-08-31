resource "kubernetes_manifest" "vmbr56_ipaddresspool" {
  depends_on = [helm_release.metallb]

  manifest = yamldecode(file("./vmbr56-ipaddresspool.yaml"))
}

resource "kubernetes_manifest" "vmbr56_l2advertisement" {
  depends_on = [helm_release.metallb]

  manifest = yamldecode(file("./vmbr56-l2advertisement.yaml"))
}
