terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "tuana9a/vn/cobi/121-anor-londo-cluster/04-csi"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.89.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
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

provider "helm" {
  kubernetes {
    host                   = "https://192.168.56.21:6443"
    cluster_ca_certificate = base64decode(local.secrets.cluster_ca_certificate_b64)
    token                  = local.secrets.cluster_auth_token
  }
}

provider "external" {
}
