terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1792512610"

    impersonate_service_account = "terraform-state-editor@tuana9a.iam.gserviceaccount.com"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.2.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.87.0"
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

ephemeral "vault_kv_secret_v2" "pve_auth" {
  mount = "kvv2"
  name  = "pve/clusters/alien/users/u/api-tokens/tf/auth"
}

provider "proxmox" {
  endpoint  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_endpoint
  api_token = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_api_token
  insecure  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_insecure == "yes"
}
