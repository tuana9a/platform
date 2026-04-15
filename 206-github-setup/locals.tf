data "external" "decrypt_secrets" {
  program = ["${path.module}/../scripts/tf_sops_decrypt.sh", "${path.module}/github_setup.enc.yml"]
}

locals {
  secrets = sensitive(yamldecode(data.external.decrypt_secrets.result.plain_text))
}