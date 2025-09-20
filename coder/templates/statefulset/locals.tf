locals {
  me = data.coder_workspace.me

  does_persist_home       = data.coder_parameter.home_persistent.value == "yes"
  home_persistent_dynamic = local.does_persist_home ? [1] : []

  has_dockerd                = data.coder_parameter.dockerd.value == "yes"
  does_persist_dockerd       = data.coder_parameter.dockerd_persistent.value == "yes"
  dockerd_dynamic            = local.has_dockerd ? [1] : []
  dockerd_persistent_dynamic = (local.has_dockerd && local.does_persist_dockerd) ? [1] : []
}
