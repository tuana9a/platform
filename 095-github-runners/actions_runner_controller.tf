# LEGACY: https://github.com/actions/actions-runner-controller/blob/master/docs/quickstart.md
resource "helm_release" "actions_runner_controller" {
  name             = "actions-runner-controller"
  namespace        = "github-runners"
  create_namespace = true
  repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart            = "actions-runner-controller"
  version          = "0.23.7"

  set {
    name  = "authSecret.create"
    value = "true"
    type  = "string"
  }

  set_sensitive {
    name  = "authSecret.github_token"
    value = var.github_token
    type  = "string"
  }
}
