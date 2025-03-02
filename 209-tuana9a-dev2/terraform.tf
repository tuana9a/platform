terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "209-tuana9a-dev2"
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

data "vault_kv_secret" "pve_token" {
  path = "kv/proxmox/pve-xeno/api-tokens/tf"
}

provider "proxmox" {
  endpoint  = data.vault_kv_secret.pve_token.data.pve_endpoint
  api_token = data.vault_kv_secret.pve_token.data.pve_api_token
  insecure  = data.vault_kv_secret.pve_token.data.insecure

  ssh {
    agent       = true
    username    = "root"
    private_key = file("~/.ssh/id_rsa")
  }
}
