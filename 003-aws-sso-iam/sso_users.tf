resource "aws_identitystore_user" "zero_tuana9a_com" {
  identity_store_id = local.sso_identity_store_id

  display_name = "Zero Two"
  user_name    = "zero@tuana9a.com"

  name {
    given_name  = "Zero"
    family_name = "Two"
  }

  emails {
    value = "zero@tuana9a.com"
  }
}
