locals {
  dns_secrets = yamldecode(data.external.decrypt_dns_secrets.result.plain_text)

  records = local.dns_secrets.records

  mx_cloudflare_routes = [
    {
      target   = "route1.mx.cloudflare.net.",
      priority = 64,
    },
    {
      target   = "route2.mx.cloudflare.net.",
      priority = 38,
    },
    {
      target   = "route3.mx.cloudflare.net.",
      priority = 47,
    },
  ]
}
