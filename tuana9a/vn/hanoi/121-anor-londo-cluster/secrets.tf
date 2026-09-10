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
