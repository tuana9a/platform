terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1788570931" # date +%s

    impersonate_service_account = "terraform-state-editor@tuana9a.iam.gserviceaccount.com"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.2.0"
    }
    coderd = {
      source  = "coder/coderd"
      version = "0.0.11"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
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

data "vault_kv_secret_v2" "coder_config" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/1788570931-tfaa"
}

provider "coderd" {
  url   = "https://coder.tuana9a.com"
  token = data.vault_kv_secret_v2.coder_config.data["coder_token"]
}

provider "vault" {
  address = "https://vault.tuana9a.com"

  skip_child_token = true
}

provider "random" {
}
