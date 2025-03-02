terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "020-proxmox-cloud-img"
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
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.0"
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

provider "proxmox" {
  endpoint  = data.vault_kv_secret.terraform.data.pve_endpoint
  api_token = data.vault_kv_secret.terraform.data.pve_api_token
}
