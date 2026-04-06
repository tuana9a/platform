terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "205-gitlab-secrets-tuana9a"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.9.0"
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

provider "gitlab" {
  token = local.gitlab_secrets.gitlab_token
}

provider "external" {
}
