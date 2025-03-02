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
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "aws" {
  region = "ap-southeast-1"
}
