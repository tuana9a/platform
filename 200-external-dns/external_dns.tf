resource "kubernetes_secret_v1" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "external-dns"
  }

  data = {
    api-token = local.secrets.cloudflare_api_token
  }
}
# dns is now managed by terraform 023-dns stack

# resource "helm_release" "external_dns" {
#   depends_on = [kubernetes_secret_v1.cloudflare_api_token]

#   name             = "external-dns"
#   namespace        = "external-dns"
#   create_namespace = true

#   repository = "https://kubernetes-sigs.github.io/external-dns"
#   chart      = "external-dns"
#   version    = "1.15.0"

#   values = [<<EOF
# provider:
#   name: cloudflare
# env:
#   - name: CF_API_TOKEN
#     valueFrom:
#       secretKeyRef:
#         name: cloudflare-api-token
#         key: api-token
# EOF
#   ]
# }
