resource "aws_identitystore_group" "admins" {
  display_name      = "Admins"
  description       = "Admins"
  identity_store_id = local.sso_identity_store_id
}