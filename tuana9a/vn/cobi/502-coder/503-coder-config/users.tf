data "vault_kv_secret_v2" "metadata" {
  mount = "kvv2"
  name  = "github.com/tuana9a/platform/tuana9a/vn/cobi/502-coder/503-coder-config/_metadata"
}

locals {
  userlist = data.vault_kv_secret_v2.metadata.data.users
}

data "vault_kv_secret_v2" "users" {
  for_each = toset(split(",", nonsensitive(local.userlist)))
  mount    = "kvv2"
  name     = "github.com/tuana9a/platform/tuana9a/vn/cobi/502-coder/503-coder-config/users/${each.key}"
}

locals {
  users = data.vault_kv_secret_v2.users
}

resource "coderd_user" "all" {
  for_each   = toset(split(",", nonsensitive(local.userlist)))
  username   = local.users[each.key].data.username
  email      = local.users[each.key].data.email
  name       = lookup(local.users[each.key].data, "name", null)
  login_type = local.users[each.key].data.login_type
  roles      = lookup(local.users[each.key].data, "roles", null) != null ? split(",", local.users[each.key].data.roles) : []
}
