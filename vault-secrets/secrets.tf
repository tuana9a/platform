resource "vault_kv_secret" "all_secrets" {
  for_each  = local.all_secrets
  path      = each.key
  data_json = jsonencode(each.value)
}

resource "vault_kv_secret_v2" "all_secrets_v2" {
  for_each  = local.all_secrets_v2
  mount     = "kvv2"
  name      = each.key
  data_json = jsonencode(each.value)
}
