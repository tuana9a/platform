terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "206-github-setup"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "github" {
  token = var.github_token
}
