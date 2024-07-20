resource "cloudflare_record" "tuana9a_dev_code_server" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "tuana9a-dev.code-server"
  value   = "127.0.0.1"
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "amon_dev_code_server" {
  zone_id = data.cloudflare_zones.tuana9a_com.zones[0].id
  name    = "amon-dev.code-server"
  value   = "127.0.0.1"
  type    = "A"
  ttl     = 60
  proxied = false
}
