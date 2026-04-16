locals {
  secrets = sensitive(yamldecode(data.external.decrypt_secrets.result.plain_text))

  runner_profiles = {
    0 = {}
  }
}
