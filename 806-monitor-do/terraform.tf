terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "806-monitor-do"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.42.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "digitalocean" {
  token = var.do_token
}
