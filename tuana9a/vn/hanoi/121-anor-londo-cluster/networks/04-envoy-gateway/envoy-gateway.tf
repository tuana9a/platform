resource "kubernetes_namespace_v1" "envoy_gateway_system" {
  metadata {
    name = "envoy-gateway-system"
  }
}

# https://gateway.envoyproxy.io/docs/tasks/quickstart/
resource "helm_release" "envoy_gateway" {
  name       = "envoy-gateway"
  namespace  = kubernetes_namespace_v1.envoy_gateway_system.metadata[0].name
  repository = "oci://docker.io/envoyproxy"
  chart      = "gateway-helm"
  version    = "v1.9.1"
}

