terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region = "us-east-1"

  access_key = var.cloudflare_access_key
  secret_key = var.cloudflare_secret_key

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
  }
}
