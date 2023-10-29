resource "cloudflare_r2_bucket" "backup" {
  account_id = local.cloudflare_account_id
  name       = "backup"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "alxmathew_backup" {
  account_id = local.cloudflare_account_id
  name       = "alxmathew-backup"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "parkngo_backup" {
  account_id = local.cloudflare_account_id
  name       = "parkngo-backup"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "public" {
  account_id = local.cloudflare_account_id
  name       = "public"
  location   = "APAC"
}
