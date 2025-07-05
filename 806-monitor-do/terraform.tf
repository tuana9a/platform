terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "806-monitor-do"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.42.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.0.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
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

data "vault_kv_secret" "do_token" {
  path = "kv/digitalocean/tuana9a/tokens/monitor-do"
}

provider "digitalocean" {
  token = data.vault_kv_secret.do_token.data.token
}
