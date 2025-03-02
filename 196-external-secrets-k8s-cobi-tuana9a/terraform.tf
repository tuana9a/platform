terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "196-external-secrets-k8s-cobi-tuana9a"
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
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}