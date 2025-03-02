terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "002-gcp-budget-alerts"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"

  # Warning:
  # If you are using User ADCs (Application Default Credentials) with this resource,
  # you must specify a billing_project and set user_project_override to true in the provider configuration.
  # Otherwise the Billing Budgets API will return a 403 error.
  # Your account must have the serviceusage.services.use permission on the billing_project you defined.
  billing_project       = var.gcp_project_name
  user_project_override = true
}
