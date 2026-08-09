variable "vault_token" {
  type      = string
  sensitive = true
}

variable "vault_jwt_auth_backend_anor_londor_cluster_oidc_discovery_ca_pem" {
  type      = string
  sensitive = true # I know it can be public, but I like it to be sensitive - ok?
}
