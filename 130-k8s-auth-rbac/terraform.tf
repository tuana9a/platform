terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "130-k8s-auth-rbac"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "external" {
}

provider "kubernetes" {
  config_path = var.kubeconfig
}
