data "vault_kv_secret" "t9stbot" {
  path = "kv/gitlab.com/tuana9a/t9stbot"
}

resource "gitlab_project_variable" "t9stbot" {
  for_each  = nonsensitive(toset(keys(data.vault_kv_secret.t9stbot.data)))
  project   = "tuana9a/t9stbot"
  key       = each.key
  value     = data.vault_kv_secret.t9stbot.data[each.key]
  protected = false
  masked    = false
}
