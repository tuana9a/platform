terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region                   = local.aws_region
  shared_credentials_files = local.aws_credential_files
  profile                  = local.aws_profile_name
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

provider "tls" {
  # Configuration options
}
