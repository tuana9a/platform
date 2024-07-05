terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "022-pages"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
