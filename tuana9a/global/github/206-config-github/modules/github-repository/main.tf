resource "github_repository" "this" {
  name         = var.name
  description  = var.description
  visibility   = var.visibility
  homepage_url = var.homepage_url
  topics       = var.topics

  auto_init          = var.auto_init
  gitignore_template = var.gitignore_template
  license_template   = var.license_template

  has_issues      = var.has_issues
  has_downloads   = var.has_downloads
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki
  has_discussions = var.has_discussions

  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  allow_auto_merge       = var.allow_auto_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  vulnerability_alerts = var.vulnerability_alerts
  archived             = var.archived
  archive_on_destroy   = var.archive_on_destroy

  dynamic "template" {
    for_each = var.template == null ? [] : [var.template]
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = false
    }
  }

  dynamic "pages" {
    for_each = var.pages == null ? [] : [var.pages]
    content {
      build_type = pages.value.build_type
      cname      = pages.value.cname

      source {
        branch = pages.value.branch
        path   = pages.value.path
      }
    }
  }
}

resource "github_branch_default" "this" {
  count      = var.default_branch != "" ? 1 : 0
  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_repository_collaborator" "this" {
  for_each = var.collaborators

  repository = github_repository.this.name
  username   = each.key
  permission = each.value
}

resource "github_team_repository" "this" {
  for_each = var.teams

  repository = github_repository.this.name
  team_id    = each.key
  permission = each.value
}

resource "github_branch_protection" "this" {
  for_each = var.branch_protections

  repository_id = github_repository.this.node_id
  pattern       = each.key

  enforce_admins          = each.value.enforce_admins
  require_signed_commits  = each.value.require_signed_commits
  required_linear_history = each.value.required_linear_history
  allows_force_pushes     = each.value.allows_force_pushes
  allows_deletions        = each.value.allows_deletions

  dynamic "required_status_checks" {
    for_each = length(each.value.required_status_checks) > 0 ? [1] : []
    content {
      strict   = each.value.strict_status_checks
      contexts = each.value.required_status_checks
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_approving_review_count > 0 ? [1] : []
    content {
      required_approving_review_count = each.value.required_approving_review_count
      dismiss_stale_reviews           = each.value.dismiss_stale_reviews
      require_code_owner_reviews      = each.value.require_code_owner_reviews
    }
  }

  depends_on = [github_branch_default.this]
}

resource "github_repository_deploy_key" "this" {
  for_each = var.deploy_keys

  repository = github_repository.this.name
  title      = each.key
  key        = each.value.key
  read_only  = each.value.read_only
}

resource "github_actions_variable" "this" {
  for_each = var.actions_variables

  repository    = github_repository.this.name
  variable_name = each.key
  value         = each.value
}

resource "github_actions_secret" "this" {
  for_each = nonsensitive(toset(keys(var.actions_secrets)))

  repository      = github_repository.this.name
  secret_name     = each.key
  plaintext_value = var.actions_secrets[each.key]
}

resource "github_repository_ruleset" "this" {
  for_each = var.rulesets

  repository  = github_repository.this.name
  name        = each.key
  target      = each.value.target
  enforcement = each.value.enforcement

  conditions {
    ref_name {
      include = each.value.include
      exclude = each.value.exclude
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  rules {
    creation                = each.value.creation
    update                  = each.value.update
    deletion                = each.value.deletion
    required_linear_history = each.value.required_linear_history
    required_signatures     = each.value.required_signatures

    dynamic "pull_request" {
      for_each = each.value.pull_request == null ? [] : [each.value.pull_request]
      content {
        dismiss_stale_reviews_on_push     = pull_request.value.dismiss_stale_reviews_on_push
        require_code_owner_review         = pull_request.value.require_code_owner_review
        require_last_push_approval        = pull_request.value.require_last_push_approval
        required_approving_review_count   = pull_request.value.required_approving_review_count
        required_review_thread_resolution = pull_request.value.required_review_thread_resolution
      }
    }
  }
}

resource "github_repository_webhook" "this" {
  for_each = var.webhooks

  repository = github_repository.this.name
  active     = each.value.active
  events     = each.value.events

  configuration {
    url          = each.value.url
    content_type = each.value.content_type
    insecure_ssl = each.value.insecure_ssl
  }
}
