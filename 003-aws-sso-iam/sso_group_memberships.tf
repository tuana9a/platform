resource "aws_identitystore_group_membership" "admin_tuana9a_com_admins" {
  identity_store_id = local.sso_identity_store_id
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.admin_tuana9a_com.user_id
}

resource "aws_identitystore_group_membership" "zero_tuana9a_com_admins" {
  identity_store_id = local.sso_identity_store_id
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.zero_tuana9a_com.user_id
}