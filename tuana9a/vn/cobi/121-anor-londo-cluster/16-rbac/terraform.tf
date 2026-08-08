terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1786028808" # date +%s
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.1.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

data "vault_kv_secret_v2" "cluster_auth" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/tuana9a/vn/cobi/121-anor-londo-cluster/16-rbac/terraform.tf"
}

provider "kubernetes" {
  host                   = "https://192.168.56.21:6443"
  cluster_ca_certificate = base64decode(data.vault_kv_secret_v2.cluster_auth.data["cluster_ca_certificate_b64"])
  token                  = data.vault_kv_secret_v2.cluster_auth.data["cluster_auth_token"]
}

provider "vault" {
  address          = "https://vault.tuana9a.com"
  skip_child_token = true
}
