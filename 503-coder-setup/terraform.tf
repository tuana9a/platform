terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "503-coder-setup"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    coderd = {
      source  = "coder/coderd"
      version = "0.0.11"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "coderd" {
  url   = "https://coder.tuana9a.com"
  token = var.coder_token
}

provider "vault" {
  address = "https://vault.tuana9a.com"
  token   = var.vault_token

  skip_child_token = true
}

provider "random" {
}
