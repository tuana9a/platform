resource "github_actions_secret" "secrets" {
  for_each = nonsensitive(toset(keys(var.repo_secrets)))

  repository      = var.repo_name
  secret_name     = each.key
  plaintext_value = var.repo_secrets[each.key]
}
