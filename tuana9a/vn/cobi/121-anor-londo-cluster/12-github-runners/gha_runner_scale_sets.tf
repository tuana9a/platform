moved {
  from = helm_release.gha_runner_scale_set_all
  to   = helm_release.gha_runner_scale_sets
}

resource "kubernetes_service_account_v1" "gha_sa" {
  metadata {
    name      = "gha-sa"
    namespace = kubernetes_namespace_v1.github_runners.metadata[0].name
  }
}

# https://docs.github.com/en/actions/tutorials/use-actions-runner-controller/quickstart
resource "helm_release" "gha_runner_scale_sets" {
  for_each   = local.runner_profiles
  name       = each.key
  namespace  = kubernetes_namespace_v1.github_runners.metadata[0].name
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set"
  version    = "0.12.1"

  set {
    name  = "githubConfigUrl"
    value = "https://github.com/tuana9a/platform"
    type  = "string"
  }

  set_sensitive {
    name  = "githubConfigSecret.github_token"
    value = data.vault_kv_secret_v2.github_runners.data["github_token"]
    type  = "string"
  }

  values = [each.value]
}

locals {
  runner_profiles = {
    self-hosted-0 = <<YAML
minRunners: 0
maxRunners: 10
# bruh https://github.com/actions/actions-runner-controller/blob/088e2a3a9029f1c85e7bd3d2539f8b8ead5947f9/charts/gha-runner-scale-set/templates/autoscalingrunnerset.yaml#L1
# to enable min and max number of runners we need to set resourceMeta.autoscalingRunnerSet some dummy value
resourceMeta:
  autoscalingRunnerSet:
    annotations:
      enabled: "yes"
template:
  spec:
    serviceAccountName: gha-sa
YAML

    vault-maintenance = <<YAML
dogminRunners: 0
maxRunners: 10
# bruh https://github.com/actions/actions-runner-controller/blob/088e2a3a9029f1c85e7bd3d2539f8b8ead5947f9/charts/gha-runner-scale-set/templates/autoscalingrunnerset.yaml#L1
# to enable min and max number of runners we need to set resourceMeta.autoscalingRunnerSet some dummy value
resourceMeta:
  autoscalingRunnerSet:
    annotations:
      enabled: "yes"
template:
  spec:
    serviceAccountName: vault-maintenance
YAML
  }
}
