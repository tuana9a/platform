resource "cloudflare_pages_project" "web" {
  account_id        = local.cloudlfare_accounts.tuana9a.id
  name              = "web"
  production_branch = "main"

  source {
    type = "gitlab"
    config {
      owner                         = "tuana9a"
      repo_name                     = "web"
      production_branch             = "main"
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }

  build_config {
    build_command   = "npm run build"
    destination_dir = "dist"
    root_dir        = ""
  }
}

resource "cloudflare_pages_domain" "web" {
  account_id   = local.cloudlfare_accounts.tuana9a.id
  project_name = cloudflare_pages_project.web.name
  domain       = "tuana9a.com"
}

resource "cloudflare_pages_project" "dkhptd_web" {
  account_id        = local.cloudlfare_accounts.tuana9a.id
  name              = "dkhptd-web"
  production_branch = "main"

  source {
    type = "github"
    config {
      owner                         = "tuana9a"
      repo_name                     = "dkhptd-web"
      production_branch             = "main"
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
    }
  }

  build_config {
    build_command   = "npm run build"
    destination_dir = "dist/dkhptd-web"
    root_dir        = ""
  }
}

resource "cloudflare_pages_domain" "dkhptd_web" {
  account_id   = local.cloudlfare_accounts.tuana9a.id
  project_name = cloudflare_pages_project.dkhptd_web.name
  domain       = "dkhptd.tuana9a.com"
}

resource "cloudflare_pages_project" "mom" {
  account_id        = local.cloudlfare_accounts.tuana9a.id
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
    }
  }
}

resource "cloudflare_pages_domain" "mom" {
  account_id   = local.cloudlfare_accounts.tuana9a.id
  project_name = cloudflare_pages_project.mom.name
  domain       = "mom.tuana9a.com"
}
