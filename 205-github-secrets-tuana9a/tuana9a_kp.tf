data "vault_kv_secret" "kp" {
  path = "kv/github.com/tuana9a/kp"
}

resource "github_actions_secret" "kp" {
  for_each        = nonsensitive(toset(keys(data.vault_kv_secret.kp.data)))
  repository      = "kp"
  secret_name     = each.key
  plaintext_value = data.vault_kv_secret.kp.data[each.key]
}
