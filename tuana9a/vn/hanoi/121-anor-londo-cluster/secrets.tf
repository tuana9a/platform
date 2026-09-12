data "vault_kv_secret_v2" "ci" {
  mount = "kvv2"
  name  = "ci"
}

ephemeral "vault_kv_secret_v2" "ci" {
  mount = "kvv2"
  name  = "ci"
}

resource "random_password" "vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

locals {
  vm_user = "u"
}

data "external" "id_rsa" {
  program = ["bash", "${path.module}/id_rsa.sh"]
  query = {
    file_content = data.vault_kv_secret_v2.ci.data.id_rsa
  }
}

locals {
  key_file = data.external.id_rsa.result.file_path
}
