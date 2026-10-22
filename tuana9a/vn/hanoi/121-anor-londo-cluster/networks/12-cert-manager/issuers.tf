data "vault_kv_secret_v2" "cert_manager" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/tuana9a/vn/hanoi/121-anor-londo-cluster/19-cert-manager/terraform"
}

resource "kubernetes_secret_v1" "cert_manager_cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name
  }

  data = {
    api-token = data.vault_kv_secret_v2.cert_manager.data.cloudflare_api_token
  }
}

resource "kubernetes_manifest" "issuers" {
  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret_v1.cert_manager_cloudflare_api_token,
  ]

  for_each = fileset(".", "cluster-issuer*")

  manifest = yamldecode(file("./${each.key}"))
}
