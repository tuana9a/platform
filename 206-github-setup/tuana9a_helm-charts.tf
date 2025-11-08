resource "github_repository" "helm-charts" {
  name          = "helm-charts"
  has_downloads = false
  has_issues    = true
  has_projects  = false
  has_wiki      = false

  pages {
    source {
      branch = "gh-pages"
      path   = "/"
    }
  }
}
