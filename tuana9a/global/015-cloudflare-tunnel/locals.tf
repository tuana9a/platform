locals {
  cloudflare_account_id = data.vault_kv_secret_v2.cf_auth.data.cloudflare_account_id
}
