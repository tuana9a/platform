resource "aws_ssoadmin_account_assignment" "group_admins_tuana9a" {
  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_id   = aws_identitystore_group.admins.group_id
  principal_type = "GROUP"

  target_id   = "384588864907" # tuana9a
  target_type = "AWS_ACCOUNT"
}
