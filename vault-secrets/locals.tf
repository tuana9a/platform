locals {
  all_secrets = yamldecode(file(var.all_secrets_file))
}
