data "vault_kv_secret" "platform" {
  path = "kv/github.com/tuana9a/platform"
}

resource "github_actions_secret" "platform" {
  for_each        = nonsensitive(toset(keys(data.vault_kv_secret.platform.data)))
  repository      = "platform"
  secret_name     = each.key
  plaintext_value = data.vault_kv_secret.platform.data[each.key]
}
