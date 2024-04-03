resource "cloudflare_r2_bucket" "backup" {
  account_id = local.cloudlfare_account_id
  name       = "backup"
  location   = "APAC"
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = cloudflare_r2_bucket.backup.id

  rule {
    id     = "one-month-expired"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}

resource "cloudflare_r2_bucket" "public" {
  account_id = local.cloudlfare_account_id
  name       = "public"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "stuffs" {
  account_id = local.cloudlfare_account_id
  name       = "stuffs"
  location   = "APAC"
}
