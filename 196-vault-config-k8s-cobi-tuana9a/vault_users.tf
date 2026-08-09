import {
  id = "auth/userpass/users/admin"
  to = vault_userpass_auth_backend_user.admin
}

resource "vault_userpass_auth_backend_user" "admin" {
  mount               = vault_auth_backend.userpass.path
  username            = "admin"
  password_wo         = var.vault_userpass_admin_password
  password_wo_version = 2

  token_policies = [vault_policy.vault_admin.name, vault_policy.secret_operator.name]
  token_ttl      = 3600
  token_max_ttl  = 7200
}
