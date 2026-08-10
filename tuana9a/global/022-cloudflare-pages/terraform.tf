terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1786320858" # date +%s 
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.43.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.23.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.10.1"
    }
  }
  required_version = ">= 1.2.0"
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

data "vault_kv_secret_v2" "terraform" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/tuana9a/global/022-cloudflare-pages/terraform.tf"
}

provider "cloudflare" {
  api_token = data.vault_kv_secret_v2.terraform.data["cloudflare_api_token"]
}
