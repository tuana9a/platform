data "cloudflare_zone" "tuana9a_com" {
  name = "tuana9a.com"
}

data "external" "decrypt_secrets" {
  program = ["${path.module}/../scripts/tf_sops_decrypt.sh", "${path.module}/dns_secrets.enc.yml"]
}
