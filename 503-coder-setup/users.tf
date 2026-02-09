data "vault_kv_secret" "metadata" {
  path = "kv/coder.tuana9a.com/users/_metadata"
}

data "vault_kv_secret" "users" {
  for_each = toset(split(",", nonsensitive(data.vault_kv_secret.metadata.data.users)))
  path     = "kv/coder.tuana9a.com/users/${each.key}"
}

resource "coderd_user" "all" {
  for_each   = toset(split(",", nonsensitive(data.vault_kv_secret.metadata.data.users)))
  username   = data.vault_kv_secret.users[each.key].data.username
  email      = data.vault_kv_secret.users[each.key].data.email
  name       = lookup(data.vault_kv_secret.users[each.key].data, "name", null)
  login_type = data.vault_kv_secret.users[each.key].data.login_type
  roles      = lookup(data.vault_kv_secret.users[each.key].data, "roles", null) != null ? split(",", data.vault_kv_secret.users[each.key].data.roles) : []
}
