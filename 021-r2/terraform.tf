terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "021-r2"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
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

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region = "us-east-1"

  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
  }
}
