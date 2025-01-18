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
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
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
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "vault" {
  address = "https://vault.tuana9a.com"

  skip_child_token = true
}

provider "cloudflare" {
  api_token = data.vault_kv_secret.edit_r2.data.cloudflare_api_token
}

provider "aws" {
  region = "us-east-1"

  access_key = data.vault_kv_secret.edit_r2.data.aws_access_key_id
  secret_key = data.vault_kv_secret.edit_r2.data.aws_secret_access_key

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    s3 = "https://${local.cloudflare_account_id}.r2.cloudflarestorage.com"
  }
}
