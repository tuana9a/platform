resource "cloudflare_record" "dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "dev"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "wildcard_dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "*.dev"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
