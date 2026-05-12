resource "kubernetes_secret_v1" "cert_manager_cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name
  }

  data = {
    api-token = local.secrets.cert-manager.cloudflare_api_token
  }
}

resource "kubernetes_manifest" "cert_manager_issuers" {
  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret_v1.cert_manager_cloudflare_api_token,
  ]

  for_each = fileset("./cert-manager-issuers", "*")

  manifest = yamldecode(file("./cert-manager-issuers/${each.key}"))
}
