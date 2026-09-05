terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1788598804" # date +%s
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.89.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.5"
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

ephemeral "vault_kv_secret_v2" "pve_auth" {
  mount = "kvv2"
  name  = "pve/clusters/alien/api-tokens/u@tf"
}

provider "proxmox" {
  endpoint  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_endpoint
  api_token = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_api_token
  insecure  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_insecure == "yes"
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

provider "external" {
}
