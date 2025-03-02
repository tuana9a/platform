terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "003-aws-sso-iam"
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
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "aws" {
  region = "ap-southeast-1"
}
