resource "cloudflare_pages_project" "dkhptd_web" {
  account_id        = var.cloudflare_account_id
  name              = "dkhptd-web"
  production_branch = "main"
}

resource "cloudflare_pages_domain" "dkhptd_web" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.dkhptd_web.name
  domain       = "dkhptd.tuana9a.com"
}

resource "cloudflare_pages_project" "mom" {
  account_id        = var.cloudflare_account_id
  name              = "mom"
  production_branch = "main"

  source {
    type = "gitlab"
    config {
      owner                         = "tuana9a"
      repo_name                     = "mom"
      production_branch             = "main"
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
      preview_deployment_setting    = "custom"
      preview_branch_includes       = ["dev"]
    }
  }
}

resource "cloudflare_pages_domain" "mom" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.mom.name
  domain       = "mom.tuana9a.com"
}

resource "cloudflare_pages_project" "paste_ui" {
  account_id        = var.cloudflare_account_id
  name              = "paste-ui"
  production_branch = "master"

  build_config {
    build_command   = "npm run build"
    destination_dir = "dist"
  }

  source {
    type = "gitlab"
    config {
      owner                         = "tuana9a"
      repo_name                     = "paste-ui"
      production_branch             = "master"
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
      preview_deployment_setting    = "custom"
      preview_branch_includes       = ["dev"]
    }
  }
}

resource "cloudflare_pages_domain" "paste_ui" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.paste_ui.name
  domain       = "paste-ui.tuana9a.com"
}
