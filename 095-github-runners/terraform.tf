terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "095-github-runners"
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

provider "helm" {
  kubernetes {
    host                   = "https://192.168.56.21:6443"
    cluster_ca_certificate = base64decode(local.secrets.cluster_ca_certificate_b64)
    token                  = local.secrets.token
  }
}

provider "external" {
}
