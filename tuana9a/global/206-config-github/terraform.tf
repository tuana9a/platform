terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1790941292"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
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
  address          = "https://vault.tuana9a.com"
  skip_child_token = true
}

ephemeral "vault_kv_secret_v2" "github_token" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/1790941292-tfaa"
}

provider "github" {
  token = ephemeral.vault_kv_secret_v2.github_token.data.github_token
}
