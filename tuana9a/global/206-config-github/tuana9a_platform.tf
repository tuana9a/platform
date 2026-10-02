resource "github_repository" "platform" {
  name          = "platform"
  has_downloads = false
  has_issues    = true
  has_projects  = false
  has_wiki      = false
}

resource "github_repository_ruleset" "platform_main" {
  repository  = github_repository.platform.name
  name        = "main"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id = 5
    # OrganizationAdmin -> 1
    # RepositoryRole (This is the actor type, the following are the base repository roles and their associated IDs.)
    # maintain -> 2
    # write -> 4
    # admin -> 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    creation                = true
    update                  = true
    deletion                = true
    required_linear_history = false
    required_signatures     = false

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 1
      required_review_thread_resolution = false
    }
  }
}

resource "github_repository_ruleset" "platform_rock-n-roll" {
  repository  = github_repository.platform.name
  name        = "rock-n-roll"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/rock-n-roll"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id = 5
    # OrganizationAdmin -> 1
    # RepositoryRole (This is the actor type, the following are the base repository roles and their associated IDs.)
    # maintain -> 2
    # write -> 4
    # admin -> 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    creation                = true
    update                  = true
    deletion                = true
    required_linear_history = false
    required_signatures     = false

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 1
      required_review_thread_resolution = false
    }
  }
}

resource "github_repository_webhook" "platform" {
  repository = github_repository.platform.name

  configuration {
    url          = "https://jenkins.tuana9a.com/github-webhook/"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["push"]
}
