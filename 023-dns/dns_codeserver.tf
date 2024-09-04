resource "cloudflare_record" "devaccess" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "devaccess"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "wildcard_devaccess" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "*.devaccess"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
