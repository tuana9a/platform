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

provider "random" {
}
