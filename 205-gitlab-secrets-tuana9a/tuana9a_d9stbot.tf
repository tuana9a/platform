data "vault_kv_secret" "d9stbot" {
  path = "kv/gitlab.com/tuana9a/d9stbot"
}

resource "gitlab_project_variable" "d9stbot" {
  for_each  = nonsensitive(toset(keys(data.vault_kv_secret.d9stbot.data)))
  project   = "tuana9a/d9stbot"
  key       = each.key
  value     = data.vault_kv_secret.d9stbot.data[each.key]
  protected = false
  masked    = false
}
