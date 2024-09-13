resource "argocd_application" "cert_manager_argoprj" {
  metadata {
    name = "cert-manager-argoprj"
  }

  wait = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
    }

    source {
      repo_url        = "https://github.com/tuana9a/platform.git"
      path            = "100-cert-manager-manifests"
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
