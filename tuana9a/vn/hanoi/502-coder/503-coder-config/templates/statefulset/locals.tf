locals {
  me = data.coder_workspace.me

  does_persist_home       = data.coder_parameter.home_disk_size.value > 0
  home_persistent_dynamic = local.does_persist_home ? [1] : []
}
