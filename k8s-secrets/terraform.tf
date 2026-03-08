terraform {
  required_providers {
    kubernetes = {
      version = "2.37.1"
    }
  }
}

provider "kubernetes" {
  host                   = "https://192.168.56.21:6443"
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate_b64)

  token = var.token
}
