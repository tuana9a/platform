resource "cloudflare_record" "knative_default" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "*.default.kn"
  value   = cloudflare_record.zione.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "knative_tuana9a" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "*.tuana9a.kn"
  value   = cloudflare_record.zione.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
