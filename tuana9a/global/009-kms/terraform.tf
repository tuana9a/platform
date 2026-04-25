terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "tuana9a/global/009-kms"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
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
    role_arn = "arn:aws:iam::384588864907:role/terraform-kms-admin"
  }
}
