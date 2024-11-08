resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "imperial-ally-285602"
  value   = "199.36.158.100"
  type    = "A"
  ttl     = 60
  proxied = false
}