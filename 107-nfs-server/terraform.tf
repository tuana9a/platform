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

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token

  ssh {
    agent       = true
    username    = var.pve_ssh_agent_username
    private_key = file(var.pve_ssh_agent_private_key_file)
  }
}

provider "random" {
}
