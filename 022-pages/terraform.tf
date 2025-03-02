terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "022-pages"
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

provider "vault" {
  address = "https://vault.tuana9a.com"

  skip_child_token = true
}

data "vault_kv_secret" "edit_pages" {
  path = "kv/cloudflare/accounts/tuana9a/api-tokens/edit-pages"
}

locals {
  cloudflare_account_id = data.vault_kv_secret.edit_pages.data.cloudflare_account_id
}

provider "cloudflare" {
  api_token = data.vault_kv_secret.edit_pages.data.cloudflare_api_token
}
