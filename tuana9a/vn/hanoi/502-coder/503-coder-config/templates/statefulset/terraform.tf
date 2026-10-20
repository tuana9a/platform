terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.20.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.28.1"
    }
  }
}

provider "coder" {
}

provider "kubernetes" {
  # Authenticate via ~/.kube/config or a Coder-specific ServiceAccount, depending on admin preferences
  config_path = var.use_kubeconfig == true ? "~/.kube/config" : null
}
