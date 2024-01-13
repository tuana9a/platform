resource "cloudflare_r2_bucket" "backup" {
  account_id = local.cloudlfare_account_id
  name       = "backup"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "public" {
  account_id = local.cloudlfare_account_id
  name       = "public"
  location   = "APAC"
}
