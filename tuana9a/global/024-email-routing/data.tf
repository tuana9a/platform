data "cloudflare_zone" "tuana9a_com" {
  name = "tuana9a.com"
}

data "vault_kv_secret_v2" "email_routing_preferences" {
  mount = "kvv2"
  name  = "cloudflare/accounts/tuana9a/domains/tuana9a.com/email-routing-preferences"
}

data "vault_kv_secret_v2" "email_routings" {
  mount = "kvv2"
  name  = "cloudflare/accounts/tuana9a/domains/tuana9a.com/email-routings"
}
