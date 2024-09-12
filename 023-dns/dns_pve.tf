resource "cloudflare_record" "pve_cobi" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "pve-cobi"
  value   = cloudflare_record.zione.hostname
  type    = "CNAME"
  ttl     = 60
  proxied = false
}
