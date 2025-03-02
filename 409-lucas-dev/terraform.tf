terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "409-lucas-dev"
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
  project = var.gcp_project_name
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

  ssh {
    agent       = true
    username    = "root"
    private_key = file("~/.ssh/id_rsa")
  }
}
