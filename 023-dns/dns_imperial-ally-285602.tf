resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "imperial-ally-285602"
  content = var.imperial_ally_285602_ip
  type    = "A"
  ttl     = 60
  proxied = false
}
