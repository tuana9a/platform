provider "cloudflare" {
  api_token = local.api_token
}

provider "aws" {
  region = "us-east-1"

  access_key = local.access_key
  secret_key = local.secret_key

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "https://${local.cloudlfare_account_id}.r2.cloudflarestorage.com"
  }
}
