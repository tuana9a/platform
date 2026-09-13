terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1789294160"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
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

data "vault_kv_secret_v2" "auth" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/1789294160-tfaa"
}

locals {
  cloudflare_account_id = data.vault_kv_secret_v2.auth.data.cloudflare_account_id
}

provider "cloudflare" {
  api_token = data.vault_kv_secret_v2.auth.data.cloudflare_api_token
}
