resource "aws_identitystore_user" "zero_tuana9a_com" {
  identity_store_id = local.sso_identity_store_id

  display_name = "Aki"
  user_name    = "zero@tuana9a.com"

  name {
    given_name  = "Aki"
    family_name = "Ng"
  }

  emails {
    value = "zero@tuana9a.com"
  }
}
