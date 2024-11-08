data "vault_kv_secret" "edit_r2" {
  path = "kv/cloudflare/accounts/tuana9a/api-tokens/edit-r2"
}

locals {
  cloudflare_account_id = data.vault_kv_secret.edit_r2.data.cloudflare_account_id
}
