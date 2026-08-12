resource "kubernetes_secret_v1" "pre_defined_secret" {
  metadata {
    name      = "pre-defined-secret"
    namespace = kubernetes_namespace_v1.github_runners.metadata[0].name
  }

  data = {
    github_token = data.vault_kv_secret_v2.github_runners.data["github_token"]
  }
}

# NEW: https://docs.github.com/en/actions/tutorials/use-actions-runner-controller/quickstart
resource "helm_release" "gha_runner_scale_set_controller" {
  name       = "arc"
  namespace  = kubernetes_namespace_v1.github_runners.metadata[0].name
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set-controller"
  version    = "0.12.1"

  set {
    # https://docs.github.com/en/actions/tutorials/use-actions-runner-controller/authenticate-to-the-api#authenticating-arc-with-a-personal-access-token-classic
    name  = "githubConfigSecret"
    value = "pre-defined-secret"
  }
}
