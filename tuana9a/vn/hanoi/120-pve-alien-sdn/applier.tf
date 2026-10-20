resource "terraform_data" "apply" {
  triggers_replace = 2
}

resource "proxmox_virtual_environment_sdn_applier" "all" {
  lifecycle {
    replace_triggered_by = [terraform_data.apply]
  }
}
