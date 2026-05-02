data "external" "decrypt_secrets" {
  program = ["${path.module}/tf_sops_decrypt.sh", "${path.module}/secrets.enc.yml"]
}