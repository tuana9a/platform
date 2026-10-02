variable "name" {
  description = "Repository name."
  type        = string
}

variable "description" {
  description = "Repository description."
  type        = string
  default     = null
}

variable "visibility" {
  description = "public, private or internal."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "visibility must be one of: public, private, internal."
  }
}

variable "homepage_url" {
  type    = string
  default = null
}

variable "topics" {
  type    = list(string)
  default = []
}

variable "default_branch" {
  type    = string
  default = "main"
}

variable "auto_init" {
  description = "Create an initial commit (required for default branch / branch protection on new repos)."
  type        = bool
  default     = true
}

variable "gitignore_template" {
  type    = string
  default = null
}

variable "license_template" {
  type    = string
  default = null
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_projects" {
  type    = bool
  default = false
}

variable "has_wiki" {
  type    = bool
  default = false
}

variable "has_discussions" {
  type    = bool
  default = false
}

variable "allow_merge_commit" {
  type    = bool
  default = false
}

variable "allow_squash_merge" {
  type    = bool
  default = true
}

variable "allow_rebase_merge" {
  type    = bool
  default = true
}

variable "allow_auto_merge" {
  type    = bool
  default = false
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "vulnerability_alerts" {
  type    = bool
  default = true
}

variable "archived" {
  type    = bool
  default = false
}

variable "archive_on_destroy" {
  description = "Archive instead of deleting the repo on terraform destroy."
  type        = bool
  default     = true
}

variable "template" {
  description = "Create the repo from a template repository."
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "collaborators" {
  description = "Map of username => permission (pull, triage, push, maintain, admin)."
  type        = map(string)
  default     = {}
}

variable "teams" {
  description = "Map of team slug => permission (pull, triage, push, maintain, admin)."
  type        = map(string)
  default     = {}
}

variable "branch_protections" {
  description = "Map of branch pattern => protection settings."
  type = map(object({
    enforce_admins                  = optional(bool, false)
    require_signed_commits          = optional(bool, false)
    required_linear_history         = optional(bool, false)
    allows_force_pushes             = optional(bool, false)
    allows_deletions                = optional(bool, false)
    required_status_checks          = optional(list(string), [])
    strict_status_checks            = optional(bool, true)
    required_approving_review_count = optional(number, 0)
    dismiss_stale_reviews           = optional(bool, true)
    require_code_owner_reviews      = optional(bool, false)
  }))
  default = {}
}

variable "deploy_keys" {
  description = "Map of title => deploy key."
  type = map(object({
    key       = string
    read_only = optional(bool, true)
  }))
  default = {}
}

variable "actions_variables" {
  description = "GitHub Actions repository variables (name => value)."
  type        = map(string)
  default     = {}
}

variable "actions_secrets" {
  description = "GitHub Actions repository secrets (name => plaintext value)."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "has_downloads" {
  description = "Deprecated by GitHub; leave null unless you need to match existing state."
  type        = bool
  default     = null
}

variable "rulesets" {
  description = "Map of ruleset name => settings (github_repository_ruleset)."
  type = map(object({
    target      = optional(string, "branch")
    enforcement = optional(string, "active")
    include     = list(string)
    exclude     = optional(list(string), [])

    bypass_actors = optional(list(object({
      actor_id    = number
      actor_type  = string
      bypass_mode = optional(string, "always")
    })), [])

    creation                = optional(bool, false)
    update                  = optional(bool, false)
    deletion                = optional(bool, false)
    required_linear_history = optional(bool, false)
    required_signatures     = optional(bool, false)

    pull_request = optional(object({
      dismiss_stale_reviews_on_push     = optional(bool, false)
      require_code_owner_review         = optional(bool, false)
      require_last_push_approval        = optional(bool, false)
      required_approving_review_count   = optional(number, 1)
      required_review_thread_resolution = optional(bool, false)
    }))
  }))
  default = {}
}

variable "webhooks" {
  description = "Map of key => webhook settings (github_repository_webhook)."
  type = map(object({
    url          = string
    content_type = optional(string, "json")
    insecure_ssl = optional(bool, false)
    active       = optional(bool, true)
    events       = list(string)
  }))
  default = {}
}

variable "pages" {
  description = "GitHub Pages config (legacy branch source). null disables Pages management."
  type = object({
    branch     = string
    path       = optional(string, "/")
    build_type = optional(string)
    cname      = optional(string)
  })
  default = null
}
