resource "cloudflare_record" "knative_default" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "*.default.knative"
  value   = cloudflare_record.zione.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "knative_dkhptd" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "*.dkhptd.knative"
  value   = cloudflare_record.zione.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
