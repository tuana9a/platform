import {
  to = kubernetes_namespace_v1.github_runners
  id = "github-runners"
}

resource "kubernetes_namespace_v1" "github_runners" {
  metadata {
    name = "github-runners"
  }
}