data "aws_ssoadmin_instances" "current" {}

locals {
  sso_arn               = tolist(data.aws_ssoadmin_instances.current.arns)[0]
  sso_identity_store_id = tolist(data.aws_ssoadmin_instances.current.identity_store_ids)[0]
}
