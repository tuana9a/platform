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

provider "bizflycloud" {
  auth_method                   = "application_credential"
  region_name                   = "HaNoi"
  application_credential_id     = var.bizflycloud_application_credential_id
  application_credential_secret = var.bizflycloud_application_credential_secret
}
