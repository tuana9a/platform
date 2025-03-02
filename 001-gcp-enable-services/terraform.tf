terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "001-gcp-enable-services"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}
