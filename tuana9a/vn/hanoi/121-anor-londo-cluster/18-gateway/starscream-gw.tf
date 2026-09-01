locals {
  envoy_gateway_ns   = data.kubernetes_namespace_v1.envoy_gateway_system.metadata[0].name
  starscream_gw_yaml = templatefile("./starscream-gw.yml", { namespace = local.envoy_gateway_ns })
  starscream_gw_manifests = {
    for i, x in split("---", local.starscream_gw_yaml) :
    i => yamldecode(x)
  }
}

resource "kubernetes_manifest" "starscream_gw" {
  for_each = local.starscream_gw_manifests

  manifest = each.value
}
