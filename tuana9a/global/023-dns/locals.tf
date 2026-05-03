locals {
  secrets = yamldecode(data.external.decrypt_secrets.result.plain_text)

  raw_records_v2 = local.secrets.records_v2
  records_v2 = {
    for i, v in flatten([
      for record_type, domains in local.raw_records_v2 : [
        for domain_name, values in domains : [
          for idx, value in values : {
            key     = "${record_type}_${domain_name}_${idx}"
            type    = record_type
            name    = domain_name
            content = value.content
            ttl     = lookup(value, "ttl", 60)
            proxied = lookup(value, "proxied", false)
            comment = lookup(value, "comment", "${record_type}_${domain_name}_${idx}")
          }
        ]
      ]
    ]) : v.key => v
  }

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
