locals {
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

resource "cloudflare_record" "mx_tuana9a_com_mx_cloudflare_net" {
  for_each = { for o in local.mx_cloudflare_routes : o.target => o }
  zone_id  = data.cloudflare_zone.tuana9a_com.id
  name     = "@"
  content  = each.value.target
  type     = "MX"
  ttl      = 60
  proxied  = false
  priority = each.value.priority
}

resource "cloudflare_record" "cf2024-1__domainkey_tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  type    = "TXT"
  name    = "cf2024-1._domainkey"
  content = "v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78km4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB"
  ttl     = 60
  proxied = false
}
