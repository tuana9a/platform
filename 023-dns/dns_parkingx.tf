data "vault_kv_secret" "parkingx_public_ip" {
  path = "kv/public-ip/parkingx"
}

resource "cloudflare_record" "parkingx" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "parkingx"
  content = data.vault_kv_secret.parkingx_public_ip.data.ip
  type    = "A"
  ttl     = 60
  proxied = false
}
