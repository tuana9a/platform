terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "087-cert-manager"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
