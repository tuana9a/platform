# data "vault_kv_secret" "zione_public_ip" {
#   path = "kv/public-ip/zione"
# }

# resource "cloudflare_record" "zione" {
#   zone_id = data.cloudflare_zone.tuana9a_com.id
#   name    = "zione"
#   value   = data.vault_kv_secret.zione_public_ip.data.ip
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }
