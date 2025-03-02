terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "030-bizflycloud-firewalls"
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
    bizflycloud = {
      source  = "bizflycloud/bizflycloud"
      version = "0.1.7"
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

  skip_child_token = true
}

data "vault_kv_secret" "terraform" {
  path = "kv/bizflycloud/accounts/tuana9a/api-tokens/terraform"
}

provider "bizflycloud" {
  auth_method                   = "application_credential"
  region_name                   = "HaNoi"
  application_credential_id     = data.vault_kv_secret.terraform.data.bizflycloud_application_credential_id
  application_credential_secret = data.vault_kv_secret.terraform.data.bizflycloud_application_credential_secret
}
