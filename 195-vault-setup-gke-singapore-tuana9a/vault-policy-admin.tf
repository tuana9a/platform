resource "vault_policy" "admin" {
  name   = "admin"
  policy = <<EOT
# Manage auth methods broadly
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create and manage policies
path "sys/policies/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}
