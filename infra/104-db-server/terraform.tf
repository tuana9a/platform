terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "infra/104-db-server"
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
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token
}
