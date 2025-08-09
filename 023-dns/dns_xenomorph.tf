resource "cloudflare_record" "xenomorph" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "xenomorph"
  content = var.xenomorph_ip
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "xeno" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "xeno"
  content = var.xenomorph_ip
  type    = "A"
  ttl     = 60
  proxied = false
}
