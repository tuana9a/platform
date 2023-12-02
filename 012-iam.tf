resource "aws_iam_group" "billing" {
  name = "BillingGroup"
}

resource "aws_iam_group_policy_attachment" "billing" {
  group      = aws_iam_group.billing.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_group" "support" {
  name = "SupportGroup"
}

resource "aws_iam_group_policy_attachment" "support" {
  group      = aws_iam_group.support.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/SupportUser"
}

resource "aws_iam_account_alias" "tuana9a" {
  account_alias = "tuana9a"
}
