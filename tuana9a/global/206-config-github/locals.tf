locals {
  admin_bypass = [{
    actor_id    = 5 # RepositoryRole: admin
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }]

  one_approval_pr = {
    dismiss_stale_reviews_on_push   = true
    required_approving_review_count = 1
  }

  repositories = {
    platform = {
      _has_secrets           = true
      default_branch         = "main"
      has_downloads          = false
      has_issues             = true
      has_projects           = false
      has_wiki               = false
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false

      collaborators = {
        tuana91a = "push"
      }
      rulesets = {
        "main" = {
          include       = ["refs/heads/main"]
          bypass_actors = local.admin_bypass
          creation      = true
          update        = true
          deletion      = true
          pull_request  = local.one_approval_pr
        }
        "rock-n-roll" = {
          include       = ["refs/heads/rock-n-roll"]
          bypass_actors = local.admin_bypass
          creation      = true
          update        = true
          deletion      = true
          pull_request  = local.one_approval_pr
        }
      }

      webhooks = {
        jenkins = {
          url    = "https://jenkins.tuana9a.com/github-webhook/"
          events = ["push"]
        }
      }
    }
    helm-charts = {
      has_downloads  = false
      has_issues     = true
      has_projects   = false
      has_wiki       = false
      default_branch = "main"

      # same overrides as platform; confirm against the plan
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false

      pages = {
        branch = "gh-pages"
        path   = "/"
      }
    }
    docker-images = {
      _has_secrets           = true
      default_branch         = "main"
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
    }
    kp = {
      _has_secrets           = true
      default_branch         = "main"
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
      archived               = true
      description            = "a kubernetes proxmox cli"
      topics = [
        "cli",
        "kubernetes",
        "proxmox",
      ]
    }
    dkhptd = {
      _has_secrets           = true
      default_branch         = "main"
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
      description            = "Đăng ký lớp tự động Đại học Bách Khoa Hà Nội"
      archived               = true
      has_projects           = true
      has_discussions        = true
    }
    web = {
      _has_secrets           = true
      default_branch         = "main"
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
    }
    spring-mongo-query-resolver = {
      _has_secrets           = true
      default_branch         = "main"
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
      description            = "Resolve mongo criteria query from string"
    }
    html2image-server = {
      visibility             = "public"
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
      collaborators = {
        tuana91a = "maintain"
      }
    }
  }
}
