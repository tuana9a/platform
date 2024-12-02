data "vault_kv_secret" "edit_tunnel" {
  path = "kv/cloudflare/accounts/tuana9a/api-tokens/edit-tunnel"
}

locals {
  cloudflare_account_id = data.vault_kv_secret.edit_tunnel.data.cloudflare_account_id
}
