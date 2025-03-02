terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "015-cloudflare-tunnel"
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
      version = "4.47.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project = var.gcp_project_name
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "vault" {
  address = "https://vault.tuana9a.com"

  skip_child_token = true
}

provider "cloudflare" {
  api_token = data.vault_kv_secret.edit_tunnel.data.cloudflare_api_token
}
