resource "cloudflare_record" "t9stbot_dev" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "t9stbot-dev"
  value   = cloudflare_record.zione.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "t9stbot" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "t9stbot"
  value   = cloudflare_record.zione.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
