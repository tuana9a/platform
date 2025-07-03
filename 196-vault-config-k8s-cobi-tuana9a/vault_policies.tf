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

resource "vault_policy" "backup" {
  name   = "backup"
  policy = <<EOT
path "sys/storage/raft/snapshot" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "dns_updater" {
  name   = "dns-updater"
  policy = <<EOT
path "kv/cloudflare/accounts/tuana9a/api-tokens/edit-dns" {
  capabilities = ["read"]
}
path "kv/public-ip/*" {
  capabilities = ["read"]
}
EOT
}
