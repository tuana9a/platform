terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "163-csi-driver-nfs-storage-classes"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
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

provider "kubernetes" {
}
