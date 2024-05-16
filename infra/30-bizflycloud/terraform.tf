terraform {
  required_providers {
    bizflycloud = {
      source  = "bizflycloud/bizflycloud"
      version = "0.1.7"
    }
  }
}

provider "bizflycloud" {
  auth_method                   = "application_credential"
  region_name                   = "HaNoi"
  application_credential_id     = var.bizflycloud_application_credential_id
  application_credential_secret = var.bizflycloud_application_credential_secret
}
