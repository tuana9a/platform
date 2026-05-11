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

moved {
  from = aws_ssoadmin_account_assignment.group_admins_Atlantis
  to   = aws_ssoadmin_account_assignment.group_admins_atlantis-tle
}

resource "aws_ssoadmin_account_assignment" "group_admins_atlantis-tle" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = local.aws_accounts.atlantis-tle.id
  target_type = "AWS_ACCOUNT"
}
