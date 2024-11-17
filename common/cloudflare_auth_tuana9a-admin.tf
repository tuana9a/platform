data "vault_kv_secret" "tuana9a_admin" {
  path = "kv/cloudflare/accounts/tuana9a/api-tokens/tuana9a-admin"
}

locals {
  cloudflare_account_id = data.vault_kv_secret.tuana9a_admin.data.cloudflare_account_id
}
