terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1788690525" # date +%s
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
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
  name  = "in-cluster/namespaces/default/serviceaccounts/zeus"
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
