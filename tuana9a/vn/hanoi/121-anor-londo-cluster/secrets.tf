data "vault_kv_secret_v2" "ci" {
  mount = "kvv2"
  name  = "ci"
}

resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

locals {
  vm_username = "u"
}

data "external" "get_join_command" {
  program = ["bash", "${path.module}/get_join_command.sh"]

  query = {
    host     = local.first_control_plane_ip
    ssh_user = local.vm_username

    ssh_key_file = local_sensitive_file.ci.filename
  }
}

locals {
  kubeadm_join_command = sensitive(data.external.get_join_command.result.join_command)
}
