resource "vault_policy" "secret_operator" {
  name   = "secret-operator"
  policy = <<EOT
# Create and manage secrets
path "${vault_mount.kv.path}/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "${vault_mount.kvv2.path}/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}
