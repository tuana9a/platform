resource "kubernetes_namespace_v1" "gateway" {
  metadata {
    name = "gateway"
  }
}

data "kubernetes_namespace_v1" "envoy_gateway_system" {
  metadata {
    name = "envoy-gateway-system"
  }
}