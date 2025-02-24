data "vault_kv_secret" "dkhptd" {
  path = "kv/github.com/tuana9a/dkhptd"
}

resource "github_actions_secret" "dkhptd" {
  for_each        = nonsensitive(toset(keys(data.vault_kv_secret.dkhptd.data)))
  repository      = "dkhptd"
  secret_name     = each.key
  plaintext_value = data.vault_kv_secret.dkhptd.data[each.key]
}
