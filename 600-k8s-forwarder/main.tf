resource "argocd_application" "k8s_forwarder" {
  metadata {
    name = "k8s-forwarder"
  }

  wait = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
    }

    source {
      repo_url        = "https://github.com/tuana9a/platform.git"
      path            = "600-k8s-forwarder-manifests"
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
