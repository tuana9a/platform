data "vault_kv_secret" "uuid" {
  path = "kv/gitlab.com/tuana9a/uuid"
}

resource "gitlab_project_variable" "uuid" {
  for_each  = nonsensitive(toset(keys(data.vault_kv_secret.uuid.data)))
  project   = "tuana9a/uuid"
  key       = each.key
  value     = data.vault_kv_secret.uuid.data[each.key]
  protected = false
  masked    = false
}
