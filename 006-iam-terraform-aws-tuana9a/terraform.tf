terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "006-iam-terraform-aws-tuana9a"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "aws" {
  region = "ap-southeast-1"
}
