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
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
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

provider "vault" {
  address = "https://vault.tuana9a.com"
  token   = var.vault_token

  skip_child_token = true
}

provider "github" {
  token = var.github_token
}
