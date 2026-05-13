terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "tuana9a/vn/cobi/112-neomorph/cloudimgs"
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
    external = {
      source  = "hashicorp/external"
      version = "2.3.5"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "proxmox" {
  endpoint  = local.secrets.pve_endpoint
  api_token = local.secrets.pve_api_token
  insecure  = local.secrets.pve_insecure
}

provider "external" {
}
