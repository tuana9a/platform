data "vault_kv_secret" "edit_pages" {
  path = "kv/cloudflare/accounts/tuana9a/api-tokens/edit-pages"
}

locals {
  cloudflare_account_id = data.vault_kv_secret.edit_pages.data.cloudflare_account_id
}
