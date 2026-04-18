resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.0"

  values = [file("./values.yaml")]
}

resource "kubernetes_secret_v1" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = helm_release.cert_manager.namespace
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
