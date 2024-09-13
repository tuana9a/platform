resource "argocd_application" "t9stbot" {
  metadata {
    name = "t9stbot"
  }

  wait = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "tuana9a"
    }

    source {
      repo_url        = "https://github.com/tuana9a/platform.git"
      path            = "510-t9stbot-manifests"
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
