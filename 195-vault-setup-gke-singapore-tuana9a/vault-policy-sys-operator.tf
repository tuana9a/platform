resource "vault_policy" "sys_operator" {
  name   = "sys-operator"
  policy = <<EOT
# Create and manage policies
path "sys/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}
