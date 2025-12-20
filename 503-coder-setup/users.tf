locals {
  users = var.coder_users
}

resource "coderd_user" "all" {
  for_each   = nonsensitive(toset(keys(local.users)))
  username   = local.users[each.key].username
  email      = local.users[each.key].email
  name       = lookup(local.users[each.key], "name", null)
  login_type = local.users[each.key].login_type
  roles      = lookup(local.users[each.key], "roles", [])
}
