terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "023-dns"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.47.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
