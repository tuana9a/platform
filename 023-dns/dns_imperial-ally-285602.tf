resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "imperial-ally-285602"
  value   = "199.36.158.100"
  type    = "A"
  ttl     = 60
  proxied = false
}