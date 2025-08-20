locals {
  runner_profiles = {
    0 = {}
  }
}

# https://docs.github.com/en/actions/tutorials/use-actions-runner-controller/quickstart
resource "helm_release" "gha_runner_scale_set_all" {
  for_each         = local.runner_profiles
  name             = "self-hosted-${each.key}"
  namespace        = "github-runners"
  create_namespace = true
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set"
  version          = "0.12.1"

  set {
    name  = "githubConfigUrl"
    value = "https://github.com/tuana9a/platform"
    type  = "string"
  }

  set_sensitive {
    name  = "githubConfigSecret.github_token"
    value = var.github_token
    type  = "string"
  }

  set {
    name  = "template.spec.serviceAccountName"
    value = "zeus"
    type  = "string"
  }
}
