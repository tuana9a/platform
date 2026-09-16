terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1789567841"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.13.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
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
  address          = "https://vault.tuana9a.com"
  skip_child_token = true
}

data "vault_kv_secret_v2" "cf_auth" {
  mount = "kvv2"
  name  = "cloudflare/accounts/tuana9a/api-tokens/edit-tunnel"
}

provider "cloudflare" {
  api_token = data.vault_kv_secret_v2.cf_auth.data.cloudflare_api_token
}

provider "random" {
}
