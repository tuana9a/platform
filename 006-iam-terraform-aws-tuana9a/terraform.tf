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
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "aws" {
  region = "ap-southeast-1"
  assume_role {
    # NOTE this role is created by this stack, so it's managing itself
    role_arn = "arn:aws:iam::384588864907:role/terraform-iam-admin"
  }
}
