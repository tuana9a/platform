terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
    }
  }
}

provider "argocd" {
  server_addr = var.argocd_server_addr
  username    = var.argocd_username
  password    = var.argocd_password
  insecure    = true
}
