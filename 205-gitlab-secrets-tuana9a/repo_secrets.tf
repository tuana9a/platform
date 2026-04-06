module "repo_secrets" {
  for_each = local.repo_names

  source = "./modules/repo-secrets"

  repo_name    = each.key
  repo_secrets = local.repo_secrets[each.key]
}

