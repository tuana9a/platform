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
      has_downloads          = false
      has_issues             = true
      has_projects           = false
      has_wiki               = false
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false

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
      has_downloads = false
      has_issues    = true
      has_projects  = false
      has_wiki      = false

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
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
    }
    kp = {
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
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
    }
    spring-mongo-query-resolver = {
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
      description            = "Resolve mongo criteria query from string"
    }
    html2image-server = {
      visibility             = "public"
      auto_init              = false
      allow_merge_commit     = true
      delete_branch_on_merge = false
      vulnerability_alerts   = false
    }
  }
}

data "vault_kv_secret_v2" "repo_secret" {
  for_each = local.repositories

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
  allow_merge_commit     = try(each.value.allow_merge_commit, false)
  delete_branch_on_merge = try(each.value.delete_branch_on_merge, true)
  vulnerability_alerts   = try(each.value.vulnerability_alerts, true)
  archive_on_destroy     = try(each.value.archive_on_destroy, true)
  description            = try(each.value.description, "")
  topics                 = try(each.value.topics, [])
  actions_secrets        = try(data.vault_kv_secret_v2.repo_secret[each.key].data, {})

  archived = try(each.value.archived, false)
  pages    = try(each.value.pages, null)
  rulesets = try(each.value.rulesets, {})
  webhooks = try(each.value.webhooks, {})
}
