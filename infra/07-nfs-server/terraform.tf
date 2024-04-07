terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.0"
    }
  }
}

provider "proxmox" {
  insecure = true
}
