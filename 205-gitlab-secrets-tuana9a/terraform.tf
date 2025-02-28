terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "205-gitlab-secrets-tuana9a"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.9.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_region_name
  zone    = var.gcp_zone_name
}

provider "vault" {
  address = "https://vault.tuana9a.com"

  skip_child_token = true
}

data "vault_kv_secret" "terraform_gitlab_secrets" {
  path = "kv/gitlab.com/tuana9a/.at/terraform-gitlab-secrets"
}

provider "gitlab" {
  token = data.vault_kv_secret.terraform_gitlab_secrets.data.token
}
