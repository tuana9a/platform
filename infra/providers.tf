terraform {
  backend "s3" {
    bucket         = "tuana9a-platform"
    key            = "infra/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tuana9a-platform"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.17.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
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

provider "local" {
  # Configuration options
}
