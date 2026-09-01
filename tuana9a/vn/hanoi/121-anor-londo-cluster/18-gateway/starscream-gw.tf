locals {
  namespace = kubernetes_namespace_v1.gateway.metadata[0].name
  starscream_gw_manifests = {
    for i, x in split("---", templatefile("./starscream-gw.yml", { namespace = local.namespace })) :
    i => yamldecode(x)
  }
}

resource "kubernetes_manifest" "starscream_gw" {
  for_each = local.starscream_gw_manifests
  manifest = each.value
}
