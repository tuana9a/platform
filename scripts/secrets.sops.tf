data "external" "decrypt_secrets" {
  program = ["${path.module}/tf_sops_decrypt.sh", "${path.module}/secrets.enc.yml"]
}

locals {
  secrets = sensitive(yamldecode(data.external.decrypt_secrets.result.plain_text))
}
