resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "imperial-ally-285602"
  value   = "199.36.158.100"
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "zione" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zione"
  value   = "123.30.48.231"
  type    = "A"
  ttl     = 60
  proxied = false
}
