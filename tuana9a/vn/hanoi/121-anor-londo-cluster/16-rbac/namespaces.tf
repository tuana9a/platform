data "kubernetes_namespace_v1" "default" {
  metadata {
    name = "default"
  }
}

data "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}

data "kubernetes_namespace_v1" "github_runners" {
  metadata {
    name = "github-runners"
  }
}
