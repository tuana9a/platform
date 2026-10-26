terraform {
  backend "gcs" {
    bucket = "terraform-tuana9a"
    prefix = "1793007079" # date +%s

    impersonate_service_account = "terraform-state-editor@tuana9a.iam.gserviceaccount.com"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.11.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.79.0"
    }
  }
}

ephemeral "vault_kv_secret_v2" "pve_auth" {
  mount = "kvv2"
  name  = "pve/clusters/alien/users/u/api-tokens/tf/auth"
}

provider "proxmox" {
  endpoint  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_endpoint
  api_token = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_api_token
  insecure  = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_insecure == "yes"

  ssh {
    # required for setup vm from cloud image
    agent       = true
    username    = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_ssh_username
    private_key = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_ssh_private_key
    node {
      name    = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_ssh_node_name
      address = ephemeral.vault_kv_secret_v2.pve_auth.data.pve_ssh_node_ip
    }
  }
}
