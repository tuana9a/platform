terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "040-proxmox-sdn-neo"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.87.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
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
}

provider "null" {
}