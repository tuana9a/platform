terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "050-gke-singapore-tuana9a"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}
