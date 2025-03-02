terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "006-iam-terraform-gcp-tuana9a"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.34.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "google-beta" {
  project = var.gcp_project_name
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}
