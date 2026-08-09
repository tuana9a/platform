resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

resource "vault_jwt_auth_backend" "in_cluster" {
  type                  = "jwt"
  oidc_discovery_url    = "https://192.168.56.21:6443"
  oidc_discovery_ca_pem = var.vault_jwt_auth_backend_anor_londor_cluster_oidc_discovery_ca_pem
  path                  = "in-cluster"
  description           = "anor londo cluster in cluster oidc"
}
