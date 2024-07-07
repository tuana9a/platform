resource "argocd_application" "dkhptd" {
  metadata {
    name = "dkhptd"
  }

  wait = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "dkhptd"
    }

    source {
      repo_url        = "https://github.com/tuana9a/platform.git"
      path            = "511-dkhptd/manifests"
      target_revision = "main"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
    }
  }
}
