locals {
  all_secrets = merge([for x in fileset(path.cwd, "${var.secret_dir}/*.yml") : yamldecode(file(x))]...)
}

module "all_secrets" {
  for_each  = local.all_secrets
  source    = "./modules/all-namespace-secrets"
  namespace = each.key
  secrets   = each.value
}
