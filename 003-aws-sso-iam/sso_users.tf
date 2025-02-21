resource "aws_identitystore_user" "admin_tuana9a_com" {
  identity_store_id = local.sso_identity_store_id

  display_name = "Tuan Nguyen"
  user_name    = "admin@tuana9a.com"

  name {
    given_name  = "Tuan"
    family_name = "Nguyen"
  }

  emails {
    value = "admin@tuana9a.com"
  }
}

resource "aws_identitystore_user" "zero_tuana9a_com" {
  identity_store_id = local.sso_identity_store_id

  display_name = "Tuan Nguyen"
  user_name    = "zero@tuana9a.com"

  name {
    given_name  = "Tuan"
    family_name = "Nguyen"
  }

  emails {
    value = "zero@tuana9a.com"
  }
}
