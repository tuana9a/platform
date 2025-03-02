terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "005-iam-workload-identity-pool-gcp-tuana9a"
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
