terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1788080022" # date +%s
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    bizflycloud = {
      source  = "bizflycloud/bizflycloud"
      version = "0.2.9"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.10.1"
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

data "vault_kv_secret_v2" "bizflycloud_auth" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/tuana9a/vn/hanoi/030-bizflycloud-firewalls/terraform"
}

provider "bizflycloud" {
  auth_method                   = "application_credential"
  region_name                   = "HaNoi"
  application_credential_id     = data.vault_kv_secret_v2.bizflycloud_auth.data.bizflycloud_application_credential_id
  application_credential_secret = data.vault_kv_secret_v2.bizflycloud_auth.data.bizflycloud_application_credential_secret
}
