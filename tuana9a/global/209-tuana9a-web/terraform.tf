terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1789294186"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.64.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.25.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "aws" {
  region = "ap-southeast-1"

  assume_role {
    role_arn = "arn:aws:iam::384588864907:role/terraform-apply-tuana9a-web"
  }
}

ephemeral "vault_kv_secret_v2" "auth" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/1789294186-tfaa"
}

provider "vault" {
  address          = "https://vault.tuana9a.com"
  skip_child_token = true
}

provider "cloudflare" {
  api_token = ephemeral.vault_kv_secret_v2.auth.data.cloudflare_api_token
}
