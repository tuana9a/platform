terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token
}
