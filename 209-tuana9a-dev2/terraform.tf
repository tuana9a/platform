terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1789563603"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
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

ephemeral "vault_kv_secret_v2" "cf_auth" {
  mount = "kvv2"
  name  = "cloudflare/accounts/tuana9a/api-tokens/edit-tunnel"
}

provider "proxmox" {
  endpoint  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_endpoint
  api_token = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_api_token
  insecure  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_insecure == "yes"

  ssh {
    agent       = true
    username    = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_ssh_username
    private_key = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_ssh_private_key
  }
}

provider "random" {
}
