data "vault_kv_secret" "paste-go" {
  path = "kv/gitlab.com/tuana9a/paste-go"
}

resource "gitlab_project_variable" "paste-go" {
  for_each  = nonsensitive(toset(keys(data.vault_kv_secret.paste-go.data)))
  project   = "tuana9a/paste-go"
  key       = each.key
  value     = data.vault_kv_secret.paste-go.data[each.key]
  protected = false
  masked    = false
}
