terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1788136629" # date +%s
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
    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.10.1"
    }
  }
}

provider "google" {
  project = "tuana9a"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}

provider "vault" {
  address          = "https://vault.tuana9a.com"
  skip_child_token = true
}

ephemeral "vault_kv_secret_v2" "cluster_auth" {
  mount = "kvv2"
  name  = "in-cluster/common"
}

provider "kubernetes" {
  host                   = "https://192.168.56.21:6443"
  cluster_ca_certificate = base64decode(ephemeral.vault_kv_secret_v2.cluster_auth.data["cluster_ca_certificate_b64"])
  token                  = ephemeral.vault_kv_secret_v2.cluster_auth.data["cluster_auth_token"]
}

provider "helm" {
  kubernetes = {
    host                   = "https://192.168.56.21:6443"
    cluster_ca_certificate = base64decode(ephemeral.vault_kv_secret_v2.cluster_auth.data["cluster_ca_certificate_b64"])
    token                  = ephemeral.vault_kv_secret_v2.cluster_auth.data["cluster_auth_token"]
  }
}
