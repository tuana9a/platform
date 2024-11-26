data "vault_kv_secret" "terraform" {
  path = "kv/pve-cobi/api-tokens/terraform"
}
