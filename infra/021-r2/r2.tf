resource "cloudflare_r2_bucket" "backup" {
  account_id = var.cloudflare_account_id
  name       = "backup"
  location   = "APAC"
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = cloudflare_r2_bucket.backup.id

  rule {
    id     = "expired-in"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}

resource "cloudflare_r2_bucket" "public" {
  account_id = var.cloudflare_account_id
  name       = "public"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "secrets" {
  account_id = var.cloudflare_account_id
  name       = "secrets"
  location   = "APAC"
}

resource "cloudflare_r2_bucket" "terraform" {
  account_id = var.cloudflare_account_id
  name       = "terraform"
  location   = "APAC"
}
