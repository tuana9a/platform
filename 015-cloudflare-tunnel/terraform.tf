terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "015-cloudflare-tunnel"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.13.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
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

provider "random" {
}