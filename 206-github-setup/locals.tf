locals {
  secrets = sensitive(yamldecode(data.external.decrypt_secrets.result.plain_text))
}