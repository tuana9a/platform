resource "aws_ssoadmin_account_assignment" "group_admins_tuana9a" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = local.aws_accounts.tuana9a.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "group_admins_t9st" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = local.aws_accounts.t9st.id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "group_admins_Atlantis" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = local.aws_accounts.Atlantis.id
  target_type = "AWS_ACCOUNT"
}
