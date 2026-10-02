data "vault_kv_secret_v2" "repo_secret" {
  for_each = { for k, v in local.repositories : k => v if can(v._has_secrets) }

  mount = "kvv2"
  name  = "github.com/tuana9a/${each.key}/_/secrets"
}

module "repo" {
  source   = "./modules/github-repository"
  for_each = local.repositories

  name                   = each.key
  has_downloads          = try(each.value.has_downloads, null)
  has_issues             = try(each.value.has_issues, true)
  has_projects           = try(each.value.has_projects, false)
  has_wiki               = try(each.value.has_wiki, false)
  visibility             = try(each.value.visibility, "private")
  auto_init              = try(each.value.auto_init, true)
  collaborators          = try(each.value.collaborators, {})
  default_branch         = try(each.value.default_branch, "")
  allow_merge_commit     = try(each.value.allow_merge_commit, false)
  delete_branch_on_merge = try(each.value.delete_branch_on_merge, true)
  vulnerability_alerts   = try(each.value.vulnerability_alerts, true)
  archive_on_destroy     = try(each.value.archive_on_destroy, true)
  description            = try(each.value.description, "")
  topics                 = try(each.value.topics, [])
  actions_secrets        = try(data.vault_kv_secret_v2.repo_secret[each.key].data, {})
  archived               = try(each.value.archived, false)
  pages                  = try(each.value.pages, null)
  rulesets               = try(each.value.rulesets, {})
  webhooks               = try(each.value.webhooks, {})
}
