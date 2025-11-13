terraform {
  required_providers {
    kubernetes = {
      version = "2.37.1"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
