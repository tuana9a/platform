resource "gitlab_project_variable" "secrets" {
  for_each = nonsensitive(toset(keys(var.repo_secrets)))

  project   = var.repo_name
  key       = each.key
  value     = var.repo_secrets[each.key]
  protected = false
  masked    = false
}
