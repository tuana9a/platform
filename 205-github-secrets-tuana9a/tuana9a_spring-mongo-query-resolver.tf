data "vault_kv_secret" "spring-mongo-query-resolver" {
  path = "kv/github.com/tuana9a/spring-mongo-query-resolver"
}

resource "github_actions_secret" "spring-mongo-query-resolver" {
  for_each        = nonsensitive(toset(keys(data.vault_kv_secret.spring-mongo-query-resolver.data)))
  repository      = "spring-mongo-query-resolver"
  secret_name     = each.key
  plaintext_value = data.vault_kv_secret.spring-mongo-query-resolver.data[each.key]
}
