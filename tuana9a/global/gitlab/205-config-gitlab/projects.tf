data "vault_kv_secret_v2" "project_secret" {
  for_each = { for k, v in local.gitlab_projects : k => v if can(v._has_variables) }

  mount = "kvv2"
  name  = "gitlab.com/tuana9a/${each.key}/_/secrets"
}

module "gitlab_project" {
  source   = "./modules/gitlab-project"
  for_each = local.gitlab_projects

  name                   = each.key
  forked_from_project_id = try(each.value.forked_from_project_id, null)
  namespace_id           = try(each.value.namespace_id, null)
  default_branch         = try(each.value.default_branch, "main")
  description            = try(each.value.description, null)
  visibility             = try(each.value.visibility, "private")
  members                = try(each.value.members, {})
  shared_groups          = try(each.value.shared_groups, {})
  branch_protections     = try(each.value.branch_protections, {})
  deploy_keys            = try(each.value.deploy_keys, {})
  hooks                  = try(each.value.hooks, {})
  ci_variables           = try({ for k, v in data.vault_kv_secret_v2.project_secret[each.key].data : k => { value = v, masked = false, protected = true } }, {})
}
