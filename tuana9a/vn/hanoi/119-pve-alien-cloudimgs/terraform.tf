terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1788697853" # date +%s
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.79.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
  }
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

ephemeral "vault_kv_secret_v2" "pve_auth" {
  mount = "kvv2"
  name  = "pve/clusters/alien/users/u/api-tokens/tf/auth"
}

provider "proxmox" {
  endpoint  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_endpoint
  api_token = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_api_token
  insecure  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_insecure == "yes"
}
