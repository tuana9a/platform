terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "infra/030-bizflycloud-firewalls"
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
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "bizflycloud" {
  auth_method                   = "application_credential"
  region_name                   = var.bizflycloud_region_name
  application_credential_id     = var.bizflycloud_application_credential_id
  application_credential_secret = var.bizflycloud_application_credential_secret
}
