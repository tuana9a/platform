data "external" "decrypt_gitlab_secrets" {
  program = ["bash", "${path.module}/decrypt_gitlab_secrets.sh"]
}

locals {
  gitlab_secrets = sensitive(yamldecode(data.external.decrypt_gitlab_secrets.result.plain_text))
  repo_secrets = local.gitlab_secrets.repo_secrets
  repo_names = nonsensitive(toset(keys(local.repo_secrets)))
}