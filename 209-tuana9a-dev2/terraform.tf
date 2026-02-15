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
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.13.0"
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

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token
  insecure  = var.pve_insecure

  ssh {
    agent       = true
    username    = var.pve_ssh_username
    private_key = var.pve_ssh_private_key
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "random" {
}
