resource "cloudflare_r2_bucket" "backup" {
  account_id = local.cloudlfare_accounts.tuana9a.id
  name       = "backup"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "public" {
  account_id = local.cloudlfare_accounts.tuana9a.id
  name       = "public"
  location   = "APAC"
}
