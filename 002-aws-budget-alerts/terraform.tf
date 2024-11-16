terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "002-aws-budget-alerts"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.24"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "aws" {
}
