resource "cloudflare_record" "xenomorph" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "xenomorph"
  content = data.vault_kv_secret.vhost_dual_x5650_public_ip.data.ip
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "xeno" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "xeno"
  content = data.vault_kv_secret.vhost_dual_x5650_public_ip.data.ip
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "pve2" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "pve2"
  content = data.vault_kv_secret.vhost_dual_x5650_public_ip.data.ip
  type    = "A"
  ttl     = 60
  proxied = false
}
