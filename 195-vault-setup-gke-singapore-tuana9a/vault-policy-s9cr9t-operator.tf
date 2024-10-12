resource "vault_policy" "secret_operator" {
  name   = "secret-operator"
  policy = <<EOT
# Create and manage secrets
path "kv/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "kvv2/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}
