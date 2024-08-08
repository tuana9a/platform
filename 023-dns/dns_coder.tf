resource "cloudflare_record" "coder" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "coder"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "wildcard_coder" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "*.coder"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
