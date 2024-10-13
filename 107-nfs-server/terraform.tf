terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "107-nfs-server"
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
      version = "0.65.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
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

provider "random" {
}
