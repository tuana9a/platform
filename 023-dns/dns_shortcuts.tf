resource "cloudflare_record" "zpr" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zpr"
  value   = cloudflare_record.zephyrus.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "ors" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "ors"
  value   = cloudflare_record.orisis.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
