terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "060-namespaces"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
