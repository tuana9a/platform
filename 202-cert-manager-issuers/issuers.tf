resource "kubernetes_secret_v1" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"
  }

  data = {
    api-token = local.secrets.cloudflare_api_token
  }
}

resource "kubernetes_manifest" "issuers" {
  depends_on = [kubernetes_secret_v1.cloudflare_api_token]

  for_each = fileset("./issuers", "*")

  manifest = yamldecode(file("./issuers/${each.key}"))
}
