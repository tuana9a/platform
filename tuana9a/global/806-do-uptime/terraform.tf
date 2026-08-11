terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1786409407"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.42.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.10.1"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

data "vault_kv_secret_v2" "do_token" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/tuana9a/global/806-do-uptime/terraform.tf"
}

provider "vault" {
  address          = "https://vault.tuana9a.com"
  skip_child_token = true
}

provider "digitalocean" {
  token = data.vault_kv_secret_v2.do_token.data["do_token"]
}
