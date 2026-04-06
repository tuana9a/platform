data "cloudflare_zone" "tuana9a_com" {
  name = "tuana9a.com"
}

data "external" "decrypt_dns_secrets" {
  program = ["bash", "${path.module}/decrypt_dns_secrets.sh"]
}
