locals {
  all_secrets = yamldecode(file(var.all_secrets_file))
}

module "all_secrets" {
  for_each  = local.all_secrets
  source    = "./modules/all-namespace-secrets"
  namespace = each.key
  secrets   = each.value
}
