terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "165-proxmox-csi-k8s-cobi"
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
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
}
