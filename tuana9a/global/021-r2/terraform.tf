terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1789294051"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.10.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.24"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
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

ephemeral "vault_kv_secret_v2" "auth" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/1789294051-tfaa"
}

data "vault_kv_secret_v2" "auth" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/1789294051-tfaa"
}

provider "cloudflare" {
  api_token = ephemeral.vault_kv_secret_v2.auth.data.cloudflare_api_token
}

locals {
  cloudflare_account_id = data.vault_kv_secret_v2.auth.data.cloudflare_account_id
}

provider "aws" {
  region = "us-east-1"

  access_key = ephemeral.vault_kv_secret_v2.auth.data.aws_access_key_id
  secret_key = ephemeral.vault_kv_secret_v2.auth.data.aws_secret_access_key

  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    s3 = "https://${ephemeral.vault_kv_secret_v2.auth.data.cloudflare_account_id}.r2.cloudflarestorage.com"
  }
}
