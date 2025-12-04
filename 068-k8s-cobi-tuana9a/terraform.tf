terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "068-k8s-cobi-tuana9a"
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
    # required for setup vm from cloud image
    agent       = true
    username    = var.pve_ssh_username
    private_key = var.pve_ssh_private_key
    node {
      name    = var.pve_ssh_node_name
      address = var.pve_ssh_node_ip
    }
  }
}

provider "random" {
}
