output "aws_ssoadmin_instances" {
  value = data.aws_ssoadmin_instances.current.arns
}

output "sso_arn" {
  value = local.sso_arn
}

output "sso_identity_store_id" {
  value = local.sso_identity_store_id
}
