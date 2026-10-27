terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1793117867"

    impersonate_service_account = "terraform-state-editor@tuana9a.iam.gserviceaccount.com"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
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
    role_arn = "arn:aws:iam::384588864907:role/terraform-ecr-admin"
  }
}
