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
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "vault" {
  address = "https://vault.tuana9a.com"

  skip_child_token = true
}

provider "bizflycloud" {
  auth_method                   = "application_credential"
  region_name                   = var.bizflycloud_region_name
  application_credential_id     = data.vault_kv_secret.terraform.data.bizflycloud_application_credential_id
  application_credential_secret = data.vault_kv_secret.terraform.data.bizflycloud_application_credential_secret
}
