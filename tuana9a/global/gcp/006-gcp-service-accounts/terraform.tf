terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1792024342"

    impersonate_service_account = "terraform-state-editor@tuana9a.iam.gserviceaccount.com"
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
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"

  impersonate_service_account = "terraform-iam-admin@tuana9a.iam.gserviceaccount.com"
}

provider "google-beta" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"

  impersonate_service_account = "terraform-iam-admin@tuana9a.iam.gserviceaccount.com"
}
