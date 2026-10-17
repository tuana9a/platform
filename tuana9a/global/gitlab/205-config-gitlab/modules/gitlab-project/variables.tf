variable "name" {
  description = "Project name."
  type        = string
}

variable "path" {
  description = "URL path/slug. Defaults to name."
  type        = string
  default     = null
}

variable "namespace_id" {
  description = "Group (namespace) ID to create the project in. null = the token owner's personal namespace."
  type        = number
  default     = null
}

variable "forked_from_project_id" {
  description = "ID of a project to fork. Applied on creation only; changing it later does not re-fork. Leave null for non-forks."
  type        = number
  default     = null
}

variable "description" {
  type    = string
  default = null
}

variable "visibility" {
  description = "private, internal or public."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "internal", "public"], var.visibility)
    error_message = "visibility must be one of: private, internal, public."
  }
}

variable "topics" {
  type    = list(string)
  default = []
}

variable "default_branch" {
  type    = string
  default = "main"
}

variable "initialize_with_readme" {
  description = "Create an initial commit. Set true for brand-new projects; leave null when importing."
  type        = bool
  default     = null
}

# Settings below default to null = "leave whatever GitLab has", so imports plan clean.

variable "merge_method" {
  description = "merge, rebase_merge or ff."
  type        = string
  default     = null
}

variable "squash_option" {
  description = "never, always, default_on or default_off."
  type        = string
  default     = null
}

variable "remove_source_branch_after_merge" {
  type    = bool
  default = null
}

variable "only_allow_merge_if_pipeline_succeeds" {
  type    = bool
  default = null
}

variable "only_allow_merge_if_all_discussions_are_resolved" {
  type    = bool
  default = null
}

variable "issues_access_level" {
  description = "disabled, private or enabled."
  type        = string
  default     = null
}

variable "merge_requests_access_level" {
  type    = string
  default = null
}

variable "wiki_access_level" {
  type    = string
  default = null
}

variable "snippets_access_level" {
  type    = string
  default = null
}

variable "container_registry_access_level" {
  type    = string
  default = null
}

variable "pages_access_level" {
  type    = string
  default = null
}

variable "archived" {
  type    = bool
  default = false
}

variable "archive_on_destroy" {
  description = "Archive instead of deleting the project on terraform destroy."
  type        = bool
  default     = true
}

variable "members" {
  description = "Map of username => access level (guest, reporter, developer, maintainer, owner)."
  type        = map(string)
  default     = {}
}

variable "shared_groups" {
  description = "Map of group ID (as string) => access level."
  type        = map(string)
  default     = {}
}

variable "branch_protections" {
  description = "Map of branch name/wildcard => protection settings."
  type = map(object({
    push_access_level            = optional(string, "maintainer")
    merge_access_level           = optional(string, "developer")
    unprotect_access_level       = optional(string, "maintainer")
    allow_force_push             = optional(bool, false)
    code_owner_approval_required = optional(bool, false)
  }))
  default = {}
}

variable "deploy_keys" {
  description = "Map of title => deploy key."
  type = map(object({
    key       = string
    can_push  = optional(bool, false)
  }))
  default = {}
}

variable "hooks" {
  description = "Map of key => project webhook. Secret tokens are not supported here (they would land in state/plans)."
  type = map(object({
    url                     = string
    push_events             = optional(bool, true)
    tag_push_events         = optional(bool, false)
    merge_requests_events   = optional(bool, false)
    enable_ssl_verification = optional(bool, true)
  }))
  default = {}
}

variable "ci_variables" {
  description = "CI/CD variables (name => settings). Set masked = true for secrets. The whole map is sensitive, so values are hidden in plans."
  type = map(object({
    value             = string
    protected         = optional(bool, false)
    masked            = optional(bool, false)
    environment_scope = optional(string, "*")
  }))
  default   = {}
  sensitive = true
}
