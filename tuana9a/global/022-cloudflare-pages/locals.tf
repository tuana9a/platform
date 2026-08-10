locals {
  cloudflare_account_id = data.vault_kv_secret_v2.terraform.data["cloudflare_account_id"]
}
