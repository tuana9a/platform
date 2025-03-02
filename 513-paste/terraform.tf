terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "513-paste"
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

data "vault_kv_secret" "edit_dns" {
  path = "kv/cloudflare/accounts/tuana9a/api-tokens/edit-dns"
}

provider "cloudflare" {
  api_token = data.vault_kv_secret.edit_dns.data.cloudflare_api_token
}
