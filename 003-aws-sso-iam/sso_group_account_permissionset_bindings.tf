resource "aws_ssoadmin_account_assignment" "group_admins_tuana9a" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = "384588864907" # tuana9a
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "group_admins_t9st" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = "445567113688" # t9st
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "group_admins_Atlantis" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = "541645813908" # Atlantis
  target_type = "AWS_ACCOUNT"
}
