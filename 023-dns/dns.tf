resource "cloudflare_record" "zephyrus" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zephyrus"
  value   = local.zephyrus_public_ip
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "imperial-ally-285602"
  value   = local.imperial_ally_285602_public_ip
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "zione" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zione"
  value   = local.zione_public_ip
  type    = "A"
  ttl     = 60
  proxied = false
}
