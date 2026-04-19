locals {
  secrets      = sensitive(yamldecode(data.external.decrypt_secrets.result.plain_text))
  repo_secrets = local.secrets.repo_secrets
  repo_names   = nonsensitive(toset(keys(local.repo_secrets)))
}