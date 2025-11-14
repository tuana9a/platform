terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.29.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.47.0"
    }
  }
  required_version = ">= 1.2.0"
}
