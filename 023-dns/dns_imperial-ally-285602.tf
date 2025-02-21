data "vault_kv_secret" "imperial_ally_285602_public_ip" {
  path = "kv/public-ip/imperial-ally-285602"
}

resource "cloudflare_record" "imperial_ally_285602" {
  zone_id = data.cloudflare_zone.tuana9a_com.id
  name    = "imperial-ally-285602"
  content = data.vault_kv_secret.imperial_ally_285602_public_ip.data.ip
  type    = "A"
  ttl     = 60
  proxied = false
}
