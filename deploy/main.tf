resource "argocd_application" "t9stbot" {
  metadata {
    name      = "t9stbot"
  }

  cascade = false # disable cascading deletion
  wait    = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }

    source {
      repo_url        = "https://gitlab.com/tuana9a/platform.git"
      path            = "deploy/t9stbot/k8s"
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

resource "argocd_application" "dkhptd" {
  metadata {
    name      = "dkhptd"
  }

  cascade = false # disable cascading deletion
  wait    = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }

    source {
      repo_url        = "https://gitlab.com/tuana9a/platform.git"
      path            = "deploy/dkhptd/k8s"
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
