# NEW: https://docs.github.com/en/actions/tutorials/use-actions-runner-controller/quickstart
resource "helm_release" "gha_runner_scale_set_controller" {
  name             = "arc"
  namespace        = "github-runners"
  create_namespace = true
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set-controller"
  version          = "0.12.1"

  set {
    # https://docs.github.com/en/actions/tutorials/use-actions-runner-controller/authenticate-to-the-api#authenticating-arc-with-a-personal-access-token-classic
    name  = "githubConfigSecret"
    value = "pre-defined-secret"
  }
}
