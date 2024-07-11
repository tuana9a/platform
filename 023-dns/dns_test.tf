resource "cloudflare_record" "test" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "test"
  value   = "1.1.1.1"
  type    = "A"
  ttl     = 1
  proxied = false

  lifecycle {
    ignore_changes = [value]
  }
}
