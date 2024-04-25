terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
