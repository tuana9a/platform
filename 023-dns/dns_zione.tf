resource "cloudflare_record" "zione" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "zione"
  value   = "123.30.48.231"
  type    = "A"
  ttl     = 60
  proxied = false
}
