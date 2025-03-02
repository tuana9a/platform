terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "025-gcp-artifact-hub-tuana9a"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}
