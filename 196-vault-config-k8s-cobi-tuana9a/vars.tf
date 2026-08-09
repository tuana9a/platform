variable "vault_jwt_auth_backend_anor_londor_cluster_oidc_discovery_ca_pem" {
  type      = string
  sensitive = true # I know it can be public, but I like it to be sensitive - ok?
}

variable "vault_userpass_admin_password" {
  type      = string
  sensitive = true
}
