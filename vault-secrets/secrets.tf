resource "vault_kv_secret" "all_secrets" {
  for_each  = local.all_secrets
  path      = each.key
  data_json = jsonencode(each.value)
}
