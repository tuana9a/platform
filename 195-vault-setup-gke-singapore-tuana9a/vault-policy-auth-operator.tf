resource "vault_policy" "auth_operator" {
  name   = "auth-operator"
  policy = <<EOT
# Manage auth methods broadly
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}
