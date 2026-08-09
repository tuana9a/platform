resource "vault_policy" "lookup_self" {
  name   = "lookup-self"
  policy = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
EOT
}

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

resource "vault_policy" "coder_tuana9a_com_setup" {
  name   = "coder-tuana9a-com-setup"
  policy = <<EOT
path "kv/coder.tuana9a.com/users/*" {
  capabilities = ["read"]
}
EOT
}

# "* cannot delete default policy" I can't delete this resource now :v
resource "vault_policy" "default" {
  name   = "default"
  policy = vault_policy.lookup_self.policy
}
