data "external" "decrypt_secrets" {
  program = ["${path.module}/../scripts/tf_sops_decrypt.sh", "${path.module}/secrets.enc.yml"]
}