terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "atlantis-tle/global/005-aws-iam"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.42.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "aws" {
  region = "ap-southeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.aws_accounts.atlantis-tle.id}:role/terraform-iam-admin"
  }
}
