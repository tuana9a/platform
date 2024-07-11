resource "cloudflare_record" "zephyrus" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "zephyrus"
  value   = file("./ip_zephyrus.secret.txt")
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "orisis" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "orisis"
  value   = file("./ip_orisis.secret.txt")
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "imperial-ally-285602"
  value   = file("./ip_imperial_ally_285602.secret.txt")
  type    = "A"
  ttl     = 60
  proxied = false
}
