data "cloudflare_zone" "tuana9a_com" {
  name = "tuana9a.com"
}

locals {
  records = yamldecode(file(var.dns_records_file))
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
