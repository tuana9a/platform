data "external" "decrypt_github_secrets" {
  program = ["bash", "${path.module}/decrypt_github_secrets.sh"]
}

locals {
  github_secrets = sensitive(yamldecode(data.external.decrypt_github_secrets.result.plain_text))
  repo_secrets = local.github_secrets.repo_secrets
  repo_names = nonsensitive(toset(keys(local.repo_secrets)))
}