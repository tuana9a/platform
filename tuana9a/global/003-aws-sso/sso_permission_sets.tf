resource "aws_ssoadmin_permission_set" "admin" {
  name             = "Admin"
  description      = "Admin"
  instance_arn     = local.sso_arn
  relay_state      = "https://ap-southeast-1.console.aws.amazon.com/ec2/home?region=ap-southeast-1#Home:"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  # Adding an explicit dependency on the account assignment resource will
  # allow the managed attachment to be safely destroyed prior to the removal
  # of the account assignment.
  depends_on = [aws_ssoadmin_account_assignment.group_admins_tuana9a]

  instance_arn       = local.sso_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}
