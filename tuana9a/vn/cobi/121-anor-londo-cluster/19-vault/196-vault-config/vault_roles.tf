resource "vault_jwt_auth_backend_role" "default" {
  backend   = vault_jwt_auth_backend.in_cluster.path
  role_name = "default"
  role_type = "jwt"
  bound_audiences = [
    "https://192.168.56.21:6443",
    "https://kubernetes.default.svc.cluster.local",
  ]
  user_claim    = "sub"
  bound_subject = "system:serviceaccount:default:default"
  token_policies = [
    vault_policy.lookup_self.name,
  ]
  token_ttl = 3600
}

# this role is managing this stack its self, so it's a cyclic dependency
# NOTE: apply manually first
resource "vault_jwt_auth_backend_role" "gha_sa" {
  backend   = vault_jwt_auth_backend.in_cluster.path
  role_name = "gha-sa"
  role_type = "jwt"
  bound_audiences = [
    "https://192.168.56.21:6443",
    "https://kubernetes.default.svc.cluster.local",
  ]
  user_claim    = "sub"
  bound_subject = "system:serviceaccount:github-runners:gha-sa"
  token_policies = [
    vault_policy.secret_operator.name,
    vault_policy.lookup_self.name,
    # --- WARN ---
    # these polices are critical, to remove/replace them, please add equivalent policy first, so that the runner can apply this stack
    vault_policy.sys_admin.name,
    vault_policy.auth_admin.name,
    vault_policy.secret_operator.name,
    # --- ENDWARN ---
  ]
  token_ttl = 3600
}

resource "vault_jwt_auth_backend_role" "vault_secret_operator" {
  backend   = vault_jwt_auth_backend.in_cluster.path
  role_name = "vault-secret-operator"
  role_type = "jwt"
  bound_audiences = [
    "https://192.168.56.21:6443",
    "https://kubernetes.default.svc.cluster.local",
  ]
  user_claim    = "sub"
  bound_subject = "system:serviceaccount:vault:vault-secret-operator"
  token_policies = [
    vault_policy.secret_operator.name,
    vault_policy.lookup_self.name,
  ]
  token_ttl = 3600
}

# this role is managing this stack its self, so it's a cyclic dependency
resource "vault_jwt_auth_backend_role" "vault_maintenance" {
  backend   = vault_jwt_auth_backend.in_cluster.path
  role_name = "vault-maintenance"
  role_type = "jwt"
  bound_audiences = [
    "https://192.168.56.21:6443",
    "https://kubernetes.default.svc.cluster.local",
  ]
  user_claim    = "sub"
  bound_subject = "system:serviceaccount:github-runners:vault-maintenance"
  token_policies = [
    vault_policy.sys_admin.name,
    vault_policy.auth_admin.name,
    vault_policy.secret_operator.name,
    vault_policy.lookup_self.name,
  ]
  token_ttl = 3600
}
