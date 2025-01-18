resource "cloudflare_r2_bucket" "backup" {
  account_id = local.cloudflare_account_id
  name       = "backup"
  location   = "APAC"
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = cloudflare_r2_bucket.backup.id

  rule {
    id     = "expired-in-7days"
    status = "Enabled"
    expiration {
      days = 7
    }
  }
}

# the same as backup but 4ever
resource "cloudflare_r2_bucket" "b4ckup" {
  account_id = local.cloudflare_account_id
  name       = "b4ckup"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "public" {
  account_id = local.cloudflare_account_id
  name       = "public"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "secrets" {
  account_id = local.cloudflare_account_id
  name       = "secrets"
  location   = "APAC"
}
