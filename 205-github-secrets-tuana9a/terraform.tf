terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "205-github-secrets-tuana9a"
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
    external = {
      source  = "hashicorp/external"
      version = "2.3.5"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "github" {
  token = local.github_secrets.github_token
}

provider "external" {
}
