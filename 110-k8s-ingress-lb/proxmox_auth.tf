data "vault_kv_secret" "terraform" {
  path = "kv/proxmox-servers/proxmox-cobi/api-tokens/terraform"
}
