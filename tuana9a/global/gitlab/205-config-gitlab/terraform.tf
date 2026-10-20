terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1792206522"

    impersonate_service_account = "terraform-state-editor@tuana9a.iam.gserviceaccount.com"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.2.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.9.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
  }
}

ephemeral "vault_kv_secret_v2" "gitlab_token" {
  mount = "kvv2"
  name  = "gitlab.com/-/tuana9a/tokens/terraform-repo-manager"
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "gitlab" {
  token = ephemeral.vault_kv_secret_v2.gitlab_token.data.gitlab_token
}
