locals {
  repo_secrets = yamldecode(file(var.repo_secrets_file))
}

module "repo_secrets" {
  for_each = local.repo_secrets

  source = "./modules/repo-secrets"

  repo_name    = each.key
  repo_secrets = each.value
}

