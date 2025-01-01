terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "001-aws-account-alias"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.24"
    }
  }
  required_version = ">= 1.2.0"
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "aws" {
  region = "ap-southeast-1"
}
