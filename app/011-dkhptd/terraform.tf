terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "app/011-dkhptd"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
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
