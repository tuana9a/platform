resource "gitlab_project" "this" {
  name             = var.name
  path             = coalesce(var.path, var.name)
  namespace_id     = var.namespace_id
  description      = var.description
  visibility_level = var.visibility
  topics           = var.topics
  default_branch   = var.default_branch

  initialize_with_readme = var.initialize_with_readme
  forked_from_project_id = var.forked_from_project_id

  merge_method                                     = var.merge_method
  squash_option                                    = var.squash_option
  remove_source_branch_after_merge                 = var.remove_source_branch_after_merge
  only_allow_merge_if_pipeline_succeeds            = var.only_allow_merge_if_pipeline_succeeds
  only_allow_merge_if_all_discussions_are_resolved = var.only_allow_merge_if_all_discussions_are_resolved

  issues_access_level             = var.issues_access_level
  merge_requests_access_level     = var.merge_requests_access_level
  wiki_access_level               = var.wiki_access_level
  snippets_access_level           = var.snippets_access_level
  container_registry_access_level = var.container_registry_access_level
  pages_access_level              = var.pages_access_level

  archived           = var.archived
  archive_on_destroy = var.archive_on_destroy
}

data "gitlab_user" "member" {
  for_each = var.members

  username = each.key
}

resource "gitlab_project_membership" "this" {
  for_each = var.members

  project      = gitlab_project.this.id
  user_id      = data.gitlab_user.member[each.key].id
  access_level = each.value
}

resource "gitlab_project_share_group" "this" {
  for_each = var.shared_groups

  project      = gitlab_project.this.id
  group_id     = tonumber(each.key)
  group_access = each.value
}

resource "gitlab_branch_protection" "this" {
  for_each = var.branch_protections

  project = gitlab_project.this.id
  branch  = each.key

  push_access_level            = each.value.push_access_level
  merge_access_level           = each.value.merge_access_level
  unprotect_access_level       = each.value.unprotect_access_level
  allow_force_push             = each.value.allow_force_push
  code_owner_approval_required = each.value.code_owner_approval_required
}

resource "gitlab_deploy_key" "this" {
  for_each = var.deploy_keys

  project  = gitlab_project.this.id
  title    = each.key
  key      = each.value.key
  can_push = each.value.can_push
}

resource "gitlab_project_hook" "this" {
  for_each = var.hooks

  project                 = gitlab_project.this.id
  url                     = each.value.url
  push_events             = each.value.push_events
  tag_push_events         = each.value.tag_push_events
  merge_requests_events   = each.value.merge_requests_events
  enable_ssl_verification = each.value.enable_ssl_verification
}

resource "gitlab_project_variable" "this" {
  # Keys are not secret; strip the mark so for_each works with a sensitive map.
  for_each = nonsensitive(toset(keys(var.ci_variables)))

  project           = gitlab_project.this.id
  key               = each.key
  value             = var.ci_variables[each.key].value
  protected         = var.ci_variables[each.key].protected
  masked            = var.ci_variables[each.key].masked
  environment_scope = var.ci_variables[each.key].environment_scope
}
