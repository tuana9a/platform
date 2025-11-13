terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
  }
}

provider "vault" {
  address = "https://vault.tuana9a.com"

  # skip_child_token = true
}
