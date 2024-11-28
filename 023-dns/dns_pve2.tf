resource "cloudflare_record" "pve2" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "pve2"
  value   = cloudflare_record.xenomorph.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
