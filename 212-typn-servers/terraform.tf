terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.79.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = var.pve_api_token
  insecure  = var.pve_insecure

  ssh {
    agent       = true
    username    = var.pve_ssh_username
    private_key = var.pve_ssh_private_key
    node {
      name    = var.pve_ssh_node_name
      address = var.pve_ssh_node_ip
    }
  }
}
