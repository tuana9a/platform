terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "092-jenkins"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.1.0"
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

provider "kubernetes" {
  host                   = "https://192.168.56.21:6443"
  cluster_ca_certificate = base64decode(local.secrets.cluster_ca_certificate_b64)

  token = local.secrets.cluster_auth_token
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
