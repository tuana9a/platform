terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "025-ecr-tuana9a"
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
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "aws" {
  region = "ap-southeast-1"
}
